import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Загрузчик срока ношения линз (общий для обеих) из [SharedPreferences].
abstract final class LensWearPeriodLoader {
  /// Ключ хранения срока в днях.
  static const prefsKey = 'lensWearingDays';

  /// Значение по умолчанию (двухнедельные линзы).
  static const defaultDays = 14;

  /// Минимальный допустимый срок.
  static const minDays = 1;

  /// Максимальный допустимый срок.
  static const maxDays = 90;

  /// Читает сохранённый срок или [defaultDays].
  static int load() {
    final raw = GetIt.I<SharedPreferences>().getInt(prefsKey);
    if (raw == null) {
      return defaultDays;
    }
    return raw.clamp(minDays, maxDays);
  }

  /// Сохраняет срок ношения в днях.
  static Future<void> save(int days) {
    return GetIt.I<SharedPreferences>().setInt(prefsKey, days.clamp(minDays, maxDays));
  }
}
