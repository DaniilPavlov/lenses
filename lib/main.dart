import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/assets_gen/fonts.gen.dart';
import 'package:lenses/controllers/lenses_controller.dart';
import 'package:lenses/main_screen.dart';
import 'package:lenses/models/toast_model.dart';
import 'package:lenses/navigation/navigator_keys.dart';
import 'package:lenses/styles/const_colors_styles.dart';
import 'package:lenses/utils/di_register.dart';
import 'package:lenses/utils/toast_handler/toast_handler_widget.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

// TODO(feature): add localization
// TODO(feature): add local puhs-notifications on lens replacing
// TODO(feature): add feature of lens' period wearing editing

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await diRegisters();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
  );
  runApp(const Lenses());
}

class Lenses extends StatelessWidget {
  const Lenses({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    final systemGestureInsets = MediaQuery.systemGestureInsetsOf(context);
    final hasButtonSystemNavigation = systemGestureInsets.left == 0;
    Widget app = MultiProvider(
      providers: [Provider<LensesController>(lazy: false, create: (context) => LensesController())],
      child: ReactionBuilder(
        builder: (context) => reaction((_) => context.read<LensesController>().pairDates, (pairDates) {
          final controller = context.read<LensesController>();
          final isLoaded = controller.isLoaded;
          if (pairDates.isValue && isLoaded) {
            _showToast(context, 'Данные обновлены', false);
          } else if (pairDates.isError) {
            _showToast(context, pairDates.error?.errorMessage ?? 'Ошибка сохранения', true);
          }
          if (!isLoaded) {
            controller.setDataLoaded();
          }
        }),
        child: MaterialApp(
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
          // localizationsDelegates: context.localizationDelegates,
          // supportedLocales: context.supportedLocales,
          // locale: context.locale,
          initialRoute: MainScreen.id,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(builder: (_) => const MainScreen(), settings: settings);
          },
        ),
      ),
    );
    // если левый(или правый) systemGestureInset больше нуля
    // значит включен режим жестовой навигации, иначе - кнопочной
    if (Platform.isAndroid && hasButtonSystemNavigation) {
      app = SafeArea(top: false, left: false, right: false, child: app);
    }
    return app;
  }

  void _showToast(BuildContext context, String message, bool isError) {
    ToastHandlerWidget.handle(
      GetIt.I.get<RootNavigatorKey>().navigatorKey.currentContext!,
      toast: ToastModel(message: message, isError: isError),
    );
  }
}
