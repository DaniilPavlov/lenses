import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lenses/common/utils/helpers/utils.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';
import 'package:lenses/l10n/app_localizations.dart';

/// Режим отображения домашнего виджета (как на главном экране).
enum LensHomeWidgetMode {
  empty,
  single,
  dual,
}

/// Акцент цвета для single-режима.
enum LensHomeWidgetAccent {
  both,
  left,
  right,
}

/// Плоский payload для native home-screen виджетов.
@immutable
class LensHomeWidgetPayload {
  const LensHomeWidgetPayload({
    required this.mode,
    required this.accent,
    required this.leftEnd,
    required this.rightEnd,
    required this.locale,
    required this.brandTitle,
    required this.titleDays,
    required this.titleReplacementDay,
    required this.titleOverdue,
    required this.labelLeft,
    required this.labelRight,
    required this.emptyHint,
  });

  static const appGroupId = 'group.com.example.lenses';
  static const androidReceiverName = 'LensesDaysWidgetReceiver';
  static const iosWidgetName = 'LensesDaysWidget';

  static const keyMode = 'mode';
  static const keyAccent = 'accent';
  static const keyLeftEnd = 'leftEnd';
  static const keyRightEnd = 'rightEnd';
  static const keyLocale = 'locale';
  static const keyBrandTitle = 'brandTitle';
  static const keyTitleDays = 'titleDays';
  static const keyTitleReplacementDay = 'titleReplacementDay';
  static const keyTitleOverdue = 'titleOverdue';
  static const keyLabelLeft = 'labelLeft';
  static const keyLabelRight = 'labelRight';
  static const keyEmptyHint = 'emptyHint';

  final LensHomeWidgetMode mode;
  final LensHomeWidgetAccent accent;
  final String leftEnd;
  final String rightEnd;
  final String locale;
  final String brandTitle;
  final String titleDays;
  final String titleReplacementDay;
  final String titleOverdue;
  final String labelLeft;
  final String labelRight;
  final String emptyHint;

  /// Строит payload из дат пары и локализованных строк.
  factory LensHomeWidgetPayload.fromPairDates(
    LensesPairDatesModel? pairDates, {
    required AppLocalizations l10n,
    required Locale locale,
  }) {
    final mapped = mapPairDatesToWidgetState(pairDates);
    return LensHomeWidgetPayload(
      mode: mapped.mode,
      accent: mapped.accent,
      leftEnd: mapped.leftEnd,
      rightEnd: mapped.rightEnd,
      locale: locale.languageCode,
      brandTitle: 'lenses',
      titleDays: l10n.daysUntilReplacement,
      titleReplacementDay: l10n.replacementDay,
      titleOverdue: l10n.replacementDayOverdue,
      labelLeft: 'L',
      labelRight: 'R',
      emptyHint: l10n.putOn,
    );
  }

  Map<String, String> toStorageMap() => {
        keyMode: mode.name,
        keyAccent: accent.name,
        keyLeftEnd: leftEnd,
        keyRightEnd: rightEnd,
        keyLocale: locale,
        keyBrandTitle: brandTitle,
        keyTitleDays: titleDays,
        keyTitleReplacementDay: titleReplacementDay,
        keyTitleOverdue: titleOverdue,
        keyLabelLeft: labelLeft,
        keyLabelRight: labelRight,
        keyEmptyHint: emptyHint,
      };
}

/// Результат маппинга дат → mode / ends / accent (без локализации).
@immutable
class LensHomeWidgetMappedState {
  const LensHomeWidgetMappedState({
    required this.mode,
    required this.accent,
    required this.leftEnd,
    required this.rightEnd,
  });

  final LensHomeWidgetMode mode;
  final LensHomeWidgetAccent accent;
  final String leftEnd;
  final String rightEnd;
}

/// Маппинг дат пары в состояние виджета (логика как у [MainScreen]).
LensHomeWidgetMappedState mapPairDatesToWidgetState(LensesPairDatesModel? pairDates) {
  if (pairDates == null || pairDates.isEmpty) {
    return const LensHomeWidgetMappedState(
      mode: LensHomeWidgetMode.empty,
      accent: LensHomeWidgetAccent.both,
      leftEnd: '',
      rightEnd: '',
    );
  }

  final left = pairDates.left;
  final right = pairDates.right;

  if (pairDates.hasBoth) {
    final leftEnd = _formatDate(left!.dateEnd);
    final rightEnd = _formatDate(right!.dateEnd);
    if (left.dateEnd.isSameDate(right.dateEnd)) {
      return LensHomeWidgetMappedState(
        mode: LensHomeWidgetMode.single,
        accent: LensHomeWidgetAccent.both,
        leftEnd: leftEnd,
        rightEnd: rightEnd,
      );
    }
    return LensHomeWidgetMappedState(
      mode: LensHomeWidgetMode.dual,
      accent: LensHomeWidgetAccent.both,
      leftEnd: leftEnd,
      rightEnd: rightEnd,
    );
  }

  if (left != null) {
    return LensHomeWidgetMappedState(
      mode: LensHomeWidgetMode.single,
      accent: LensHomeWidgetAccent.left,
      leftEnd: _formatDate(left.dateEnd),
      rightEnd: '',
    );
  }

  return LensHomeWidgetMappedState(
    mode: LensHomeWidgetMode.single,
    accent: LensHomeWidgetAccent.right,
    leftEnd: '',
    rightEnd: _formatDate(right!.dateEnd),
  );
}

/// Дни до замены: [dateEnd] − сегодня (0 = день замены; как в [LensesController]).
int daysLeftUntil(DateTime dateEnd, {DateTime? now}) {
  final today = _dateOnly(now ?? DateTime.now());
  return _dateOnly(dateEnd).difference(today).inDays;
}

String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(_dateOnly(date));

DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
