import 'dart:convert';

import 'package:lenses/core/lenses/controllers/lenses_controller/lenses_controller.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';

abstract final class ControllerFixtures {
  static DateTime get startDate => DateTime(2026);

  static DateTime get fixedNow => DateTime(2026, 6, 15);

  static LensDateModel get leftLensDate =>
      LensDateModel(dateStart: startDate, dateEnd: startDate.add(const Duration(days: 14)), daysLeft: 10);

  static LensDateModel get rightLensDate => LensDateModel(
    dateStart: startDate.add(const Duration(days: 1)),
    dateEnd: startDate.add(const Duration(days: 15)),
    daysLeft: 9,
  );

  static LensesPairDatesModel get pairDates => LensesPairDatesModel(left: leftLensDate, right: rightLensDate);

  static String get pairDatesJson => json.encode(pairDates.toJson());

  static LensesController controller({
    String? Function()? loadPairDatesRaw,
    Future<void> Function(String json)? savePairDatesRaw,
    Future<void> Function()? clearPairDatesRaw,
    int? Function()? loadWearingDays,
    Future<void> Function(int days)? saveWearingDays,
    DateTime Function()? now,
  }) =>
      LensesController(
        autoLoad: false,
        loadPairDatesRaw: loadPairDatesRaw ?? () => null,
        savePairDatesRaw: savePairDatesRaw ?? (_) async {},
        clearPairDatesRaw: clearPairDatesRaw ?? () async {},
        loadWearingDays: loadWearingDays ?? () => LensesControllerBase.defaultWearingDays,
        saveWearingDays: saveWearingDays ?? (_) async {},
        now: now ?? () => fixedNow,
      );
}
