// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lenses_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LensesController on LensesControllerBase, Store {
  late final _$wearingDaysAtom = Atom(
    name: 'LensesControllerBase.wearingDays',
    context: context,
  );

  @override
  int get wearingDays {
    _$wearingDaysAtom.reportRead();
    return super.wearingDays;
  }

  @override
  set wearingDays(int value) {
    _$wearingDaysAtom.reportWrite(value, super.wearingDays, () {
      super.wearingDays = value;
    });
  }

  late final _$pairDatesAtom = Atom(
    name: 'LensesControllerBase.pairDates',
    context: context,
  );

  @override
  AsyncValue<LensesPairDatesModel?> get pairDates {
    _$pairDatesAtom.reportRead();
    return super.pairDates;
  }

  @override
  set pairDates(AsyncValue<LensesPairDatesModel?> value) {
    _$pairDatesAtom.reportWrite(value, super.pairDates, () {
      super.pairDates = value;
    });
  }

  late final _$LensesControllerBaseActionController = ActionController(
    name: 'LensesControllerBase',
    context: context,
  );

  @override
  void updateLensesPair({
    required DateTime? leftDate,
    required DateTime? rightDate,
  }) {
    final _$actionInfo = _$LensesControllerBaseActionController.startAction(
      name: 'LensesControllerBase.updateLensesPair',
    );
    try {
      return super.updateLensesPair(leftDate: leftDate, rightDate: rightDate);
    } finally {
      _$LensesControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setWearingDays(int days) {
    final _$actionInfo = _$LensesControllerBaseActionController.startAction(
      name: 'LensesControllerBase.setWearingDays',
    );
    try {
      return super.setWearingDays(days);
    } finally {
      _$LensesControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void putOffLensesSheet({required BuildContext context}) {
    final _$actionInfo = _$LensesControllerBaseActionController.startAction(
      name: 'LensesControllerBase.putOffLensesSheet',
    );
    try {
      return super.putOffLensesSheet(context: context);
    } finally {
      _$LensesControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void putOffLensesPair({required bool left, required bool right}) {
    final _$actionInfo = _$LensesControllerBaseActionController.startAction(
      name: 'LensesControllerBase.putOffLensesPair',
    );
    try {
      return super.putOffLensesPair(left: left, right: right);
    } finally {
      _$LensesControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadLensesDates() {
    final _$actionInfo = _$LensesControllerBaseActionController.startAction(
      name: 'LensesControllerBase.loadLensesDates',
    );
    try {
      return super.loadLensesDates();
    } finally {
      _$LensesControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
wearingDays: ${wearingDays},
pairDates: ${pairDates}
    ''';
  }
}
