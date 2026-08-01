import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'locale_controller.g.dart';

/// MobX-контроллер локали приложения (ru по умолчанию).
class LocaleController = LocaleControllerBase with _$LocaleController;

/// Хранит и переключает локаль приложения.
abstract class LocaleControllerBase with Store {
  static const _prefsKey = 'app_locale';
  static const supportedLocales = [Locale('ru'), Locale('en')];

  @observable
  Locale locale = const Locale('ru');

  @computed
  bool get isRussian => locale.languageCode == 'ru';

  @computed
  String get localeCodeLabel => isRussian ? 'RU' : 'EN';

  /// Загружает сохранённую локаль; без значения — русский (сразу пишется в prefs).
  @action
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    if (code == null) {
      locale = const Locale('ru');
      await prefs.setString(_prefsKey, 'ru');
      return;
    }
    locale = code == 'en' ? const Locale('en') : const Locale('ru');
  }

  /// Переключает локаль между ru и en.
  @action
  Future<void> toggle() async {
    await setLocale(isRussian ? const Locale('en') : const Locale('ru'));
  }

  /// Устанавливает и сохраняет локаль.
  @action
  Future<void> setLocale(Locale value) async {
    if (locale == value) return;
    locale = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, value.languageCode);
  }
}
