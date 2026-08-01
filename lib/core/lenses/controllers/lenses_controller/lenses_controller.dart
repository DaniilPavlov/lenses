import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lenses/common/utils/helpers/mobx_async_value.dart';
import 'package:lenses/core/lenses/components/put_on_end_sheet.dart';
import 'package:lenses/core/lenses/loaders/lens_wear_period_loader.dart';
import 'package:lenses/core/lenses/loaders/lenses_dates_loader.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';
import 'package:mobx/mobx.dart';

part 'lenses_controller.g.dart';

/// MobX-контроллер дат ношения линз.
class LensesController = LensesControllerBase with _$LensesController;

/// Управляет загрузкой, обновлением и снятием пары дат ношения.
abstract class LensesControllerBase with Store {
  LensesControllerBase({
    String? Function()? loadPairDatesRaw,
    Future<void> Function(String json)? savePairDatesRaw,
    Future<void> Function()? clearPairDatesRaw,
    int? Function()? loadWearingDays,
    Future<void> Function(int days)? saveWearingDays,
    DateTime Function()? now,
    bool autoLoad = true,
  }) : _loadPairDatesRawOverride = loadPairDatesRaw,
       _savePairDatesRawOverride = savePairDatesRaw,
       _clearPairDatesRawOverride = clearPairDatesRaw,
       _loadWearingDaysOverride = loadWearingDays,
       _saveWearingDaysOverride = saveWearingDays,
       _nowOverride = now {
    wearingDays = _loadWearingDays();
    if (autoLoad) {
      loadLensesDates();
    }
  }

  /// Срок ношения по умолчанию (совпадает с [LensWearPeriodLoader.defaultDays]).
  static const defaultWearingDays = LensWearPeriodLoader.defaultDays;

  final String? Function()? _loadPairDatesRawOverride;
  final Future<void> Function(String json)? _savePairDatesRawOverride;
  final Future<void> Function()? _clearPairDatesRawOverride;
  final int? Function()? _loadWearingDaysOverride;
  final Future<void> Function(int days)? _saveWearingDaysOverride;
  final DateTime Function()? _nowOverride;

  /// Общий срок ношения обеих линз в днях.
  @observable
  int wearingDays = defaultWearingDays;

  /// Текущее состояние пары дат ношения.
  @observable
  AsyncValue<LensesPairDatesModel?> pairDates = const AsyncValue.loading();

  /// Флаг первой успешной/ошибочной реакции после старта (чтобы не показывать toast при автозагрузке).
  bool isLoaded = false;

  /// Обновляет даты старта левой и/или правой линзы и пересчитывает срок ношения.
  @action
  void updateLensesPair({required DateTime? leftDate, required DateTime? rightDate}) {
    final current = pairDates.value;
    final updated = LensesPairDatesModel(
      left: leftDate != null ? _createLensDate(leftDate) : current?.left,
      right: rightDate != null ? _createLensDate(rightDate) : current?.right,
    );
    _setPairDates(updated.isEmpty ? null : updated);
  }

  /// Переносит выбранные линзы на «сегодня» (замена).
  void renewLenses({required bool left, required bool right}) {
    final now = _now();
    updateLensesPair(leftDate: left ? now : null, rightDate: right ? now : null);
  }

  /// Задаёт общий срок ношения и пересчитывает даты замены от текущих стартов.
  @action
  void setWearingDays(int days) {
    final next = days.clamp(LensWearPeriodLoader.minDays, LensWearPeriodLoader.maxDays);
    if (next == wearingDays) {
      return;
    }
    wearingDays = next;
    _saveWearingDays(next);
    final current = pairDates.value;
    if (current == null || current.isEmpty) {
      return;
    }
    _setPairDates(_recalculatePairDates(current));
  }

  /// Показывает sheet выбора, какую линзу снять, либо сразу снимает единственную.
  @action
  void putOffLensesSheet({required BuildContext context}) {
    final current = pairDates.value;
    if (current == null || !current.hasBoth) {
      putOffLensesPair(left: true, right: true);
      return;
    }

    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (sheetContext) {
        return PutOnEndSheet(
          onLeftConfirmed: () {
            putOffLensesPair(left: true, right: false);
            Navigator.of(sheetContext).pop();
          },
          onRightConfirmed: () {
            putOffLensesPair(left: false, right: true);
            Navigator.of(sheetContext).pop();
          },
          onBothConfirmed: () {
            putOffLensesPair(left: true, right: true);
            Navigator.of(sheetContext).pop();
          },
        );
      },
    );
  }

  /// Снимает указанные линзы и сохраняет новое состояние.
  @action
  void putOffLensesPair({required bool left, required bool right}) {
    final current = pairDates.value;
    final updated = LensesPairDatesModel(left: left ? null : current?.left, right: right ? null : current?.right);
    _setPairDates(updated.isEmpty ? null : updated);
  }

  /// Загружает даты из хранилища и пересчитывает [LensDateModel.daysLeft].
  @action
  void loadLensesDates() {
    final pairDatesRaw = _loadPairDatesRaw();
    if (pairDatesRaw == null) {
      pairDates = const AsyncValue.value();
      return;
    }

    try {
      final loaded = LensesPairDatesModel.fromJson(jsonDecode(pairDatesRaw) as Map<String, dynamic>);
      final recalculated = _recalculatePairDates(loaded);
      pairDates = AsyncValue.value(value: recalculated.isEmpty ? null : recalculated);
    } catch (e) {
      pairDates = const AsyncValue.error(error: AsyncError(errorMessage: 'loadError'));
    }
  }

  /// Отмечает, что первичная реакция на [pairDates] уже обработана.
  void setDataLoaded() {
    isLoaded = true;
  }

  /// Применяет новое значение [pairDates] и синхронизирует его с хранилищем.
  void _setPairDates(LensesPairDatesModel? value) {
    pairDates = AsyncValue.value(value: value);
    _persistPairDates(value);
  }

  String? _loadPairDatesRaw() {
    final load = _loadPairDatesRawOverride;
    if (load != null) {
      return load();
    }
    return LensesDatesLoader.loadRaw();
  }

  Future<void> _persistPairDates(LensesPairDatesModel? value) {
    if (value == null || value.isEmpty) {
      return _clearPairDates();
    }
    return _savePairDates(json.encode(value.toJson()));
  }

  Future<void> _savePairDates(String json) {
    final save = _savePairDatesRawOverride;
    if (save != null) {
      return save(json);
    }
    return LensesDatesLoader.saveRaw(json);
  }

  Future<void> _clearPairDates() {
    final clear = _clearPairDatesRawOverride;
    if (clear != null) {
      return clear();
    }
    return LensesDatesLoader.clear();
  }

  int _loadWearingDays() {
    final load = _loadWearingDaysOverride;
    if (load != null) {
      return (load() ?? defaultWearingDays).clamp(
        LensWearPeriodLoader.minDays,
        LensWearPeriodLoader.maxDays,
      );
    }
    return LensWearPeriodLoader.load();
  }

  Future<void> _saveWearingDays(int days) {
    final save = _saveWearingDaysOverride;
    if (save != null) {
      return save(days);
    }
    return LensWearPeriodLoader.save(days);
  }

  /// Создаёт модель даты ношения от [dateStart] на [wearingDays] дней.
  LensDateModel _createLensDate(DateTime dateStart) {
    final normalizedStart = _dateOnly(dateStart);
    final dateEnd = normalizedStart.add(Duration(days: wearingDays));
    return LensDateModel(dateStart: normalizedStart, dateEnd: dateEnd, daysLeft: _daysLeftUntil(dateEnd));
  }

  /// Пересчитывает [daysLeft] для сохранённой пары относительно «сегодня».
  LensesPairDatesModel _recalculatePairDates(LensesPairDatesModel model) {
    return LensesPairDatesModel(
      left: model.left != null ? _createLensDate(model.left!.dateStart) : null,
      right: model.right != null ? _createLensDate(model.right!.dateStart) : null,
    );
  }

  /// Сколько календарных дней осталось до дня замены [dateEnd] (0 = день замены).
  int _daysLeftUntil(DateTime dateEnd) {
    return _dateOnly(dateEnd).difference(_dateOnly(_now())).inDays;
  }

  DateTime _now() => _nowOverride?.call() ?? DateTime.now();

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
}
