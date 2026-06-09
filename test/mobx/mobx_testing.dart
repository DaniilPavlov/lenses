// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:flutter_test/flutter_test.dart' as test;
import 'package:meta/meta.dart';
import 'package:mobx/mobx.dart';

@isTest
void mobxTest<S extends Store, T>(
  String description, {
  required S Function() build,
  required T Function(S store) value,
  FutureOr<void> Function()? setUp,
  FutureOr<void> Function()? tearDown,
  FutureOr<void> Function(S store)? act,
  dynamic Function()? expect,
  dynamic Function(S store)? verify,
  bool fireInitialState = true,
}) {
  test.test(description, () async {
    late S store;
    final changes = <T>[];
    late ReactionDisposer disposer;

    setUp?.call();
    store = build();

    disposer = reaction(
      (_) => value(store),
      changes.add,
      fireImmediately: fireInitialState,
    );

    await act?.call(store);
    await Future<void>.delayed(Duration.zero);

    if (expect != null) {
      final expected = await expect();
      test.expect(changes, test.wrapMatcher(expected));
    }

    await verify?.call(store);
    tearDown?.call();
    disposer();
  });
}
