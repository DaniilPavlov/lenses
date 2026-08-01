import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/core/lenses/loaders/lens_wear_period_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('LensWearPeriodLoader', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await GetIt.I.reset();
      GetIt.I.registerSingleton<SharedPreferences>(await SharedPreferences.getInstance());
    });

    tearDown(() async {
      await GetIt.I.reset();
    });

    test('load returns default when unset', () {
      expect(LensWearPeriodLoader.load(), LensWearPeriodLoader.defaultDays);
    });

    test('save and load round-trip', () async {
      await LensWearPeriodLoader.save(7);
      expect(LensWearPeriodLoader.load(), 7);
    });

    test('load clamps out-of-range stored values', () async {
      await GetIt.I<SharedPreferences>().setInt(LensWearPeriodLoader.prefsKey, 500);
      expect(LensWearPeriodLoader.load(), LensWearPeriodLoader.maxDays);
    });
  });
}
