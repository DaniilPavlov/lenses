// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lenses_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LensesController on LensesControllerBase, Store {
  late final _$_pairDatesAtom = Atom(
    name: 'LensesControllerBase._pairDates',
    context: context,
  );

  @override
  AsyncValue<LensesPairDatesModel?> get _pairDates {
    _$_pairDatesAtom.reportRead();
    return super._pairDates;
  }

  @override
  set _pairDates(AsyncValue<LensesPairDatesModel?> value) {
    _$_pairDatesAtom.reportWrite(value, super._pairDates, () {
      super._pairDates = value;
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
  void _putOffLensesPair({required bool left, required bool right}) {
    final _$actionInfo = _$LensesControllerBaseActionController.startAction(
      name: 'LensesControllerBase._putOffLensesPair',
    );
    try {
      return super._putOffLensesPair(left: left, right: right);
    } finally {
      _$LensesControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _loadLensesDates() {
    final _$actionInfo = _$LensesControllerBaseActionController.startAction(
      name: 'LensesControllerBase._loadLensesDates',
    );
    try {
      return super._loadLensesDates();
    } finally {
      _$LensesControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
