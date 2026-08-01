import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/common/utils/constants/navigator_keys.dart';
import 'package:lenses/common/utils/extensions/getit_extension.dart';
import 'package:lenses/services/notifications/lens_replacement_reminder_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Регистрация контейнеров DI библиотеки get_it.
Future<void> diRegisters() async {
  final sp = await SharedPreferences.getInstance();
  GetIt.I.tryRegisterSingleton<SharedPreferences>(sp);
  GetIt.I.tryRegisterSingleton<RootNavigatorKey>(RootNavigatorKey(GlobalKey<NavigatorState>()));
  GetIt.I.tryRegisterSingleton<LensReplacementReminderService>(LensReplacementReminderService());
}
