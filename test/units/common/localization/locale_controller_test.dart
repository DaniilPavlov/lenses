import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/common/localization/locale_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('defaults to russian and toggles to english', () async {
    final controller = LocaleController();
    expect(controller.isRussian, isTrue);
    expect(controller.localeCodeLabel, 'RU');

    await controller.toggle();
    expect(controller.locale, const Locale('en'));
    expect(controller.isRussian, isFalse);
    expect(controller.localeCodeLabel, 'EN');

    await controller.toggle();
    expect(controller.isRussian, isTrue);
  });

  test('load restores saved english locale', () async {
    SharedPreferences.setMockInitialValues({'app_locale': 'en'});
    final controller = LocaleController();
    await controller.load();
    expect(controller.locale, const Locale('en'));
  });

  test('setLocale no-ops when unchanged', () async {
    final controller = LocaleController();
    await controller.setLocale(const Locale('ru'));
    expect(controller.locale, const Locale('ru'));
  });
}
