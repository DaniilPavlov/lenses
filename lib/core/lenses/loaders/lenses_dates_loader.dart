import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract final class LensesDatesLoader {
  static const pairDatesKey = 'pairDates';

  static String? loadRaw() => GetIt.I<SharedPreferences>().getString(pairDatesKey);

  static Future<void> saveRaw(String json) => GetIt.I<SharedPreferences>().setString(pairDatesKey, json);

  static Future<void> clear() => GetIt.I<SharedPreferences>().remove(pairDatesKey);
}
