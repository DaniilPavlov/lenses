// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locale_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocaleController on LocaleControllerBase, Store {
  Computed<bool>? _$isRussianComputed;

  @override
  bool get isRussian => (_$isRussianComputed ??= Computed<bool>(
    () => super.isRussian,
    name: 'LocaleControllerBase.isRussian',
  )).value;
  Computed<String>? _$localeCodeLabelComputed;

  @override
  String get localeCodeLabel => (_$localeCodeLabelComputed ??= Computed<String>(
    () => super.localeCodeLabel,
    name: 'LocaleControllerBase.localeCodeLabel',
  )).value;

  late final _$localeAtom = Atom(
    name: 'LocaleControllerBase.locale',
    context: context,
  );

  @override
  Locale get locale {
    _$localeAtom.reportRead();
    return super.locale;
  }

  @override
  set locale(Locale value) {
    _$localeAtom.reportWrite(value, super.locale, () {
      super.locale = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    'LocaleControllerBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$toggleAsyncAction = AsyncAction(
    'LocaleControllerBase.toggle',
    context: context,
  );

  @override
  Future<void> toggle() {
    return _$toggleAsyncAction.run(() => super.toggle());
  }

  late final _$setLocaleAsyncAction = AsyncAction(
    'LocaleControllerBase.setLocale',
    context: context,
  );

  @override
  Future<void> setLocale(Locale value) {
    return _$setLocaleAsyncAction.run(() => super.setLocale(value));
  }

  @override
  String toString() {
    return '''
locale: ${locale},
isRussian: ${isRussian},
localeCodeLabel: ${localeCodeLabel}
    ''';
  }
}
