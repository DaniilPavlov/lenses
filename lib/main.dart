import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/app.dart';
import 'package:lenses/common/localization/locale_controller.dart';
import 'package:lenses/services/di_register.dart';
import 'package:lenses/services/notifications/lens_replacement_reminder_service.dart';
import 'package:lenses/services/widgets/lens_home_widget_service.dart';
import 'package:provider/provider.dart';

/// Точка входа: DI, уведомления и запуск [App].
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await diRegisters();

  final reminders = GetIt.I<LensReplacementReminderService>();
  await reminders.init();
  await reminders.requestPermissions();
  await GetIt.I<LensHomeWidgetService>().init();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
  );
  runApp(
    Provider(
      create: (_) => LocaleController(),
      child: const App(),
    ),
  );
}
