import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lenses/common/utils/helpers/mobx_async_value.dart';
import 'package:lenses/core/lenses/components/put_on_end_sheet.dart';
import 'package:lenses/core/lenses/loaders/lenses_dates_loader.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';
import 'package:mobx/mobx.dart';

part 'lenses_controller.g.dart';

class LensesController = LensesControllerBase with _$LensesController;

abstract class LensesControllerBase with Store {
  LensesControllerBase({
    String? Function()? loadPairDatesRaw,
    Future<void> Function(String json)? savePairDatesRaw,
    Future<void> Function()? clearPairDatesRaw,
    DateTime Function()? now,
    bool autoLoad = true,
  }) : _loadPairDatesRawOverride = loadPairDatesRaw,
       _savePairDatesRawOverride = savePairDatesRaw,
       _clearPairDatesRawOverride = clearPairDatesRaw,
       _nowOverride = now {
    if (autoLoad) {
      loadLensesDates();
    }
  }

  static const lensWearingDays = 14;

  final String? Function()? _loadPairDatesRawOverride;
  final Future<void> Function(String json)? _savePairDatesRawOverride;
  final Future<void> Function()? _clearPairDatesRawOverride;
  final DateTime Function()? _nowOverride;

  @observable
  AsyncValue<LensesPairDatesModel?> pairDates = const AsyncValue.loading();

  bool isLoaded = false;

  @action
  void updateLensesPair({required DateTime? leftDate, required DateTime? rightDate}) {
    final current = pairDates.value;
    final updated = LensesPairDatesModel(
      left: leftDate != null ? _createLensDate(leftDate) : current?.left,
      right: rightDate != null ? _createLensDate(rightDate) : current?.right,
    );
    _setPairDates(updated.isEmpty ? null : updated);
  }

  void renewLenses({required bool left, required bool right}) {
    final now = _now();
    updateLensesPair(leftDate: left ? now : null, rightDate: right ? now : null);
  }

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

  @action
  void putOffLensesPair({required bool left, required bool right}) {
    final current = pairDates.value;
    final updated = LensesPairDatesModel(left: left ? null : current?.left, right: right ? null : current?.right);
    _setPairDates(updated.isEmpty ? null : updated);
  }

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
      pairDates = const AsyncValue.error(error: AsyncError(errorMessage: 'Не удалось загрузить сохранённые данные'));
    }
  }

  void setDataLoaded() {
    isLoaded = true;
  }

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

  LensDateModel _createLensDate(DateTime dateStart) {
    final normalizedStart = _dateOnly(dateStart);
    final dateEnd = normalizedStart.add(const Duration(days: lensWearingDays));
    return LensDateModel(dateStart: normalizedStart, dateEnd: dateEnd, daysLeft: _daysLeftUntil(dateEnd));
  }

  LensesPairDatesModel _recalculatePairDates(LensesPairDatesModel model) {
    return LensesPairDatesModel(
      left: model.left != null ? _createLensDate(model.left!.dateStart) : null,
      right: model.right != null ? _createLensDate(model.right!.dateStart) : null,
    );
  }

  int _daysLeftUntil(DateTime dateEnd) {
    return _dateOnly(dateEnd).difference(_dateOnly(_now())).inDays + 1;
  }

  DateTime _now() => _nowOverride?.call() ?? DateTime.now();

  DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);
}
