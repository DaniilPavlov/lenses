import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Загрузчик сырых JSON-дат ношения из [SharedPreferences].
abstract final class LensesDatesLoader {
  /// Ключ хранения пары дат.
  static const pairDatesKey = 'pairDates';

  /// Читает сохранённый JSON или `null`, если данных нет.
  static String? loadRaw() => GetIt.I<SharedPreferences>().getString(pairDatesKey);

  /// Сохраняет JSON пары дат.
  static Future<void> saveRaw(String json) => GetIt.I<SharedPreferences>().setString(pairDatesKey, json);

  /// Удаляет сохранённые даты.
  static Future<void> clear() => GetIt.I<SharedPreferences>().remove(pairDatesKey);
}
