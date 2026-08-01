import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/common/utils/helpers/mobx_async_value.dart';

void main() {
  group('AsyncValue', () {
    test('status getters', () {
      const loading = AsyncValue<int>.loading();
      const value = AsyncValue<int>.value(value: 1);
      const error = AsyncValue<int>.error(error: AsyncError(errorMessage: 'x'));

      expect(loading.isLoading, isTrue);
      expect(loading.isValue, isFalse);
      expect(value.isValue, isTrue);
      expect(error.isError, isTrue);
      expect(error.error?.errorMessage, 'x');
    });

    test('equality and toString', () {
      const a = AsyncValue<int>.value(value: 1);
      const b = AsyncValue<int>.value(value: 1);
      const c = AsyncValue<int>.value(value: 2);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a == c, isFalse);
      expect(a.toString(), contains('AsyncValue'));
      expect(const AsyncError(errorMessage: 'e').toString(), contains('e'));
      expect(const AsyncError(errorMessage: 'e'), equals(const AsyncError(errorMessage: 'e')));
    });
  });
}
