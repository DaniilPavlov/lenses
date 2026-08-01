import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/assets_gen/fonts.gen.dart';
import 'package:lenses/common/localization/locale_controller.dart';
import 'package:lenses/common/utils/constants/navigator_keys.dart';
import 'package:lenses/common/utils/helpers/mobx_async_value.dart';
import 'package:lenses/common/utils/theme/const_colors_styles.dart';
import 'package:lenses/common/utils/toast_handler/toast_handler_widget.dart';
import 'package:lenses/core/lenses/controllers/lenses_controller/lenses_controller.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';
import 'package:lenses/core/lenses/models/toast_model.dart';
import 'package:lenses/core/lenses/screens/main_screen.dart';
import 'package:lenses/l10n/app_localizations.dart';
import 'package:lenses/services/notifications/lens_replacement_reminder_service.dart';
import 'package:lenses/services/widgets/lens_home_widget_service.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

/// Корневой виджет приложения: тема, локаль, тосты и реакция на даты линз.
class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(context.read<LocaleController>().load());
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final systemGestureInsets = MediaQuery.systemGestureInsetsOf(context);
    final hasButtonSystemNavigation = systemGestureInsets.left == 0;
    final localeController = context.read<LocaleController>();

    Widget app = MultiProvider(
      providers: [Provider<LensesController>(lazy: false, create: (context) => LensesController())],
      child: ReactionBuilder(
        builder: (context) => reaction((_) => context.read<LensesController>().pairDates, (pairDates) {
          final controller = context.read<LensesController>();
          final isLoaded = controller.isLoaded;
          unawaited(_onPairDatesChanged(
            pairDates: pairDates,
            isLoaded: isLoaded,
            locale: localeController.locale,
            onFirstLoadDone: controller.setDataLoaded,
          ));
        }),
        child: ReactionBuilder(
          builder: (context) => reaction((_) => localeController.locale, (locale) {
            final pair = context.read<LensesController>().pairDates.value;
            unawaited(GetIt.I<LensReplacementReminderService>().sync(pair, locale: locale));
            unawaited(GetIt.I<LensHomeWidgetService>().sync(pair, locale: locale));
          }),
          child: Observer(
            builder: (context) {
              return MaterialApp(
                locale: localeController.locale,
                supportedLocales: LocaleControllerBase.supportedLocales,
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: ThemeData(
                  useMaterial3: true,
                  splashFactory: NoSplash.splashFactory,
                  highlightColor: Colors.transparent,
                  typography: Typography.material2014(platform: defaultTargetPlatform),
                  canvasColor: AppColors.pureColors.white.o100,
                  fontFamily: FontFamily.rfDewi,
                  popupMenuTheme: PopupMenuThemeData(
                    surfaceTintColor: AppColors.pureColors.white.o100,
                    color: AppColors.pureColors.white.o100,
                  ),
                  scaffoldBackgroundColor: Colors.white,
                  appBarTheme: AppBarTheme(surfaceTintColor: AppColors.pureColors.white.o100),
                  textSelectionTheme: TextSelectionThemeData(
                    selectionColor: AppColors.pureColors.green.g100,
                    selectionHandleColor: AppColors.pureColors.green.g500,
                  ),
                  tabBarTheme: const TabBarThemeData(overlayColor: WidgetStatePropertyAll(Colors.transparent)),
                ),
                navigatorKey: GetIt.I.get<RootNavigatorKey>().navigatorKey,
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
                    child: ToastHandlerWidget(child: child!),
                  );
                },
                initialRoute: MainScreen.id,
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(builder: (_) => const MainScreen(), settings: settings);
                },
              );
            },
          ),
        ),
      ),
    );
    if (Platform.isAndroid && hasButtonSystemNavigation) {
      app = SafeArea(top: false, left: false, right: false, child: app);
    }
    return app;
  }

  Future<void> _onPairDatesChanged({
    required AsyncValue<LensesPairDatesModel?> pairDates,
    required bool isLoaded,
    required Locale locale,
    required VoidCallback onFirstLoadDone,
  }) async {
    final l10n = await AppLocalizations.delegate.load(locale);
    if (pairDates.isValue && isLoaded) {
      _showToast(l10n.dataUpdated, false);
    } else if (pairDates.isError) {
      _showToast(l10n.loadError, true);
    }
    if (!isLoaded) {
      onFirstLoadDone();
    }
    await GetIt.I<LensReplacementReminderService>().sync(pairDates.value, locale: locale);
    await GetIt.I<LensHomeWidgetService>().sync(pairDates.value, locale: locale);
  }

  /// Показывает toast через корневой [ToastHandlerWidget].
  void _showToast(String message, bool isError) {
    final ctx = GetIt.I.get<RootNavigatorKey>().navigatorKey.currentContext;
    if (ctx == null) {
      return;
    }
    ToastHandlerWidget.handle(
      ctx,
      toast: ToastModel(message: message, isError: isError),
    );
  }
}
