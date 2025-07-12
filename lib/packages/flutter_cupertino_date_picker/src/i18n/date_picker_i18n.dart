// ignore_for_file: avoid_positional_boolean_parameters, constant_identifier_names

import 'dart:math';

part 'strings_en_us.dart';

part 'strings_ru.dart';

part 'strings_sr_cyr.dart';
part 'strings_sr_lat.dart';

abstract class StringsI18n {
  const StringsI18n();

  /// Get the done widget text
  String? getDoneText();

  /// Get the cancel widget text
  String? getCancelText();

  /// Get the name of month
  List<String>? getMonths();

  /// Get the short name of month
  List<String>? getMonthsShort();

  /// Get the full name of week
  List<String>? getWeeksFull();

  /// Get the short name of week
  List<String>? getWeeksShort();
}

enum DateTimePickerLocale {
  /// English (EN) United States
  en_us,

  /// Chinese (ZH) Simplified
  zh_cn,

  /// Portuguese (PT) Brazil
  pt_br,

  /// Indonesia (ID)
  id,

  /// Spanish (ES)
  es,

  /// Turkish (TR)
  tr,

  /// French (FR)
  fr,

  /// Romanian (RO)
  ro,

  /// Bengali (BN)
  bn,

  /// Bosnian (BS)
  bs,

  /// Arabic (ar)
  ar,

  /// Arabic (ar) Egypt
  ar_eg,

  /// Japanese (JP)
  jp,

  /// Russian (RU)
  ru,

  /// German (DE)
  de,

  /// Korea (KO)
  ko,

  /// Italian (IT)
  it,

  /// Hungarian (HU)
  hu,

  /// Croatian (HR)
  hr,

  /// Ukrainian (UK)
  uk,

  /// Vietnamese (VN)
  vi,

  /// Serbia (sr) Cyrillic
  sr_cyrl,

  /// Serbia (sr) Latin
  sr_latn,

  /// Dutch (NL)
  nl,
}

/// Default value of date locale
const DateTimePickerLocale DATETIME_PICKER_LOCALE_DEFAULT =
    DateTimePickerLocale.en_us;

const Map<DateTimePickerLocale, StringsI18n> datePickerI18n = {
  DateTimePickerLocale.en_us: _StringsEnUs(),
  DateTimePickerLocale.sr_cyrl: _StringsSrCyrillic(),
  DateTimePickerLocale.sr_latn: _StringsSrLatin(),
  DateTimePickerLocale.ru: _StringsRu(),
};

class DatePickerI18n {
  /// Get done button text
  static String? getLocaleDone(DateTimePickerLocale locale) {
    final i18n = datePickerI18n[locale] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;
    return i18n.getDoneText() ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getDoneText();
  }

  /// Get cancel button text
  static String getLocaleCancel(DateTimePickerLocale locale) {
    final i18n = datePickerI18n[locale] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;
    return i18n.getCancelText() ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getCancelText()!;
  }

  /// Get locale month array
  static List<String> getLocaleMonths(
    DateTimePickerLocale locale, [
    bool isFull = true,
  ]) {
    final i18n = datePickerI18n[locale] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;

    if (isFull) {
      final months = i18n.getMonths();
      if (months != null && months.isNotEmpty) {
        return months;
      }
      return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getMonths()!;
    }

    final months = i18n.getMonthsShort();
    if (months != null && months.isNotEmpty && months.length == 12) {
      return months;
    }
    return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getMonthsShort()!;
  }

  /// Get locale week array
  static List<String> getLocaleWeeks(
    DateTimePickerLocale locale, [
    bool isFull = true,
  ]) {
    final i18n = datePickerI18n[locale] ??
        datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!;
    if (isFull) {
      final weeks = i18n.getWeeksFull();
      if (weeks != null && weeks.isNotEmpty) {
        return weeks;
      }
      return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getWeeksFull()!;
    }

    final weeks = i18n.getWeeksShort();
    if (weeks != null && weeks.isNotEmpty) {
      return weeks;
    }

    final fullWeeks = i18n.getWeeksFull();
    if (fullWeeks != null && fullWeeks.isNotEmpty) {
      return fullWeeks
          .map((item) => item.substring(0, min(3, item.length)))
          .toList();
    }
    return datePickerI18n[DATETIME_PICKER_LOCALE_DEFAULT]!.getWeeksShort()!;
  }
}
