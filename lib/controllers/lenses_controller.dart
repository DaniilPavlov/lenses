import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/models/generated/generated.dart';
import 'package:lenses/widgets/sheets/put_on_end_sheet.dart';
import 'package:lenses/utils/logger.dart';
import 'package:lenses/utils/mobx_async_value.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'lenses_controller.g.dart';

class LensesController = LensesControllerBase with _$LensesController;

abstract class LensesControllerBase with Store {
  LensesControllerBase() {
    _loadLensesDates();
  }

  @observable
  AsyncValue<LensesPairDatesModel?> _pairDates = const AsyncValue.loading();

  AsyncValue<LensesPairDatesModel?> get pairDates => _pairDates;

  bool isLoaded = false;

  @action
  void updateLensesPair({
    required DateTime? leftDate,
    required DateTime? rightDate,
  }) {
    final parsedLeftDate = leftDate != null
        ? LensDateModel(
            dateStart: leftDate,
            dateEnd: leftDate.add(const Duration(days: 14)),
            daysLeft: leftDate.add(const Duration(days: 14)).difference(DateTime.now()).inDays,
          )
        : _pairDates.value?.left;
    final parsedRightDate = rightDate != null
        ? LensDateModel(
            dateStart: rightDate,
            dateEnd: rightDate.add(const Duration(days: 14)),
            daysLeft: rightDate.add(const Duration(days: 14)).difference(DateTime.now()).inDays,
          )
        : _pairDates.value?.right;
    _pairDates = AsyncValue.value(value: LensesPairDatesModel(left: parsedLeftDate, right: parsedRightDate));
    final prefs = GetIt.I<SharedPreferences>();
    prefs.setString('pairDates', json.encode(_pairDates.value?.toJson()));
  }

  @action
  void putOffLensesSheet({required BuildContext context}) {
    if (_pairDates.value?.left == null || _pairDates.value?.right == null) {
      _putOffLensesPair(left: true, right: true);
    } else {
      showModalBottomSheet<void>(
        isScrollControlled: true,
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.8),
        builder: (context) {
          return PutOnEndSheet(
            onLeftConfirmed: () {
              _putOffLensesPair(left: true, right: false);
              Navigator.of(context).pop();
            },
            onRightConfirmed: () {
              _putOffLensesPair(left: false, right: true);
              Navigator.of(context).pop();
            },
            onBothConfirmed: () {
              _putOffLensesPair(left: true, right: true);
              Navigator.of(context).pop();
            },
          );
        },
      );
    }
  }

  @action
  void _putOffLensesPair({required bool left, required bool right}) {
    if (left) {
      _pairDates = AsyncValue.value(value: LensesPairDatesModel(left: null, right: _pairDates.value?.right));
    }
    if (right) {
      _pairDates = AsyncValue.value(value: LensesPairDatesModel(left: _pairDates.value?.left, right: null));
    }
    final prefs = GetIt.I<SharedPreferences>();
    prefs.setString('pairDates', json.encode(_pairDates.value?.toJson()));
  }

  @action
  void _loadLensesDates() {
    final prefs = GetIt.I<SharedPreferences>();
    final pairDatesRaw = prefs.getString('pairDates');
    if (pairDatesRaw != null) {
      try {
        _pairDates = AsyncValue.value(
          value: LensesPairDatesModel.fromJson(jsonDecode(pairDatesRaw)),
        );
      } catch (e) {
        _pairDates = AsyncValue.error(
          error: AsyncError(
            errorMessage: '_loadLensesDates error: $e',
          ),
        );
        logger.e('_loadLensesDates error: $e');
      }
    }
  }

  void setDataLoaded() {
    isLoaded = true;
  }
}
