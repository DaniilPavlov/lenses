import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/navigation/navigator_keys.dart';
import 'package:lenses/utils/extensions/getit_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Регистрация контейнеров DI библиотеки get_it
Future<void> diRegisters() async {
  final sp = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton<SharedPreferences>(sp);
  GetIt.I.tryRegisterSingleton<RootNavigatorKey>(RootNavigatorKey(GlobalKey<NavigatorState>()));
}
