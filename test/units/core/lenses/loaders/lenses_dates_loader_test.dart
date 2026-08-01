import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/core/lenses/loaders/lenses_dates_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    await GetIt.I.reset();
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    GetIt.I.registerSingleton<SharedPreferences>(prefs);
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  test('loadRaw returns null when empty', () {
    expect(LensesDatesLoader.loadRaw(), isNull);
  });

  test('saveRaw / loadRaw / clear', () async {
    await LensesDatesLoader.saveRaw('{"left":null,"right":null}');
    expect(LensesDatesLoader.loadRaw(), '{"left":null,"right":null}');

    await LensesDatesLoader.clear();
    expect(LensesDatesLoader.loadRaw(), isNull);
  });
}
