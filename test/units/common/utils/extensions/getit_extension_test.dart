import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/common/utils/extensions/getit_extension.dart';

void main() {
  setUp(() async {
    await GetIt.I.reset();
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  test('getOrNull returns null when unregistered', () {
    expect(GetIt.I.getOrNull<String>(), isNull);
  });

  test('tryRegisterSingleton registers once', () {
    GetIt.I.tryRegisterSingleton<String>('a');
    GetIt.I.tryRegisterSingleton<String>('b');
    expect(GetIt.I<String>(), 'a');
    expect(GetIt.I.getOrNull<String>(), 'a');
  });
}
