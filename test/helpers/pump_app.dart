import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/l10n/app_localizations.dart';

/// Обёртка для widget-тестов: l10n + опциональный wrap (Provider и т.п.).
extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    Locale locale = const Locale('en'),
    Size surfaceSize = const Size(390, 844),
    bool wrapInScaffold = true,
    Widget Function(Widget app)? wrapApp,
  }) async {
    await binding.setSurfaceSize(surfaceSize);
    addTearDown(() => binding.setSurfaceSize(null));

    view.physicalSize = surfaceSize;
    view.devicePixelRatio = 1;
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetDevicePixelRatio);

    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      final isOverflow =
          details.exceptionAsString().contains('A RenderFlex overflowed') ||
          details.exceptionAsString().contains('overflowed by');
      if (isOverflow) {
        return;
      }
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    final home = wrapInScaffold ? Scaffold(body: widget) : widget;
    Widget app = MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: home,
    );
    if (wrapApp != null) {
      app = wrapApp(app);
    }

    await pumpWidget(app);
    await pump();
  }
}
