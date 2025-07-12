// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toast_handler_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ToastHandlerController on _ToastHandlerControllerBase, Store {
  late final _$_toastsAtom =
      Atom(name: '_ToastHandlerControllerBase._toasts', context: context);

  @override
  List<ToastModel> get _toasts {
    _$_toastsAtom.reportRead();
    return super._toasts;
  }

  @override
  set _toasts(List<ToastModel> value) {
    _$_toastsAtom.reportWrite(value, super._toasts, () {
      super._toasts = value;
    });
  }

  late final _$_ToastHandlerControllerBaseActionController =
      ActionController(name: '_ToastHandlerControllerBase', context: context);

  @override
  void handleToast(ToastModel toast) {
    final _$actionInfo = _$_ToastHandlerControllerBaseActionController
        .startAction(name: '_ToastHandlerControllerBase.handleToast');
    try {
      return super.handleToast(toast);
    } finally {
      _$_ToastHandlerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeToast() {
    final _$actionInfo = _$_ToastHandlerControllerBaseActionController
        .startAction(name: '_ToastHandlerControllerBase.removeToast');
    try {
      return super.removeToast();
    } finally {
      _$_ToastHandlerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
