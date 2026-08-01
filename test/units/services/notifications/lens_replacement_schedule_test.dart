import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';
import 'package:lenses/services/notifications/lens_replacement_schedule.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  group('nextLensReplacement', () {
    test('returns null for empty pair', () {
      expect(nextLensReplacement(null), isNull);
      expect(nextLensReplacement(const LensesPairDatesModel()), isNull);
    });

    test('left only', () {
      final pair = LensesPairDatesModel(left: ControllerFixtures.leftLensDate);
      final next = nextLensReplacement(pair)!;
      expect(next.which, ReplacementTarget.left);
      expect(next.date, ControllerFixtures.leftLensDate.dateEnd);
    });

    test('right only', () {
      final pair = LensesPairDatesModel(right: ControllerFixtures.rightLensDate);
      final next = nextLensReplacement(pair)!;
      expect(next.which, ReplacementTarget.right);
    });

    test('both same end date', () {
      final end = DateTime(2026, 1, 15);
      final pair = LensesPairDatesModel(
        left: LensDateModel(dateStart: DateTime(2026), dateEnd: end, daysLeft: 1),
        right: LensDateModel(dateStart: DateTime(2026), dateEnd: end, daysLeft: 1),
      );
      expect(nextLensReplacement(pair)!.which, ReplacementTarget.both);
    });

    test('both picks earlier end', () {
      final earlier = DateTime(2026, 1, 10);
      final later = DateTime(2026, 1, 20);
      final leftFirst = LensesPairDatesModel(
        left: LensDateModel(dateStart: DateTime(2026), dateEnd: earlier, daysLeft: 1),
        right: LensDateModel(dateStart: DateTime(2026), dateEnd: later, daysLeft: 1),
      );
      expect(nextLensReplacement(leftFirst)!.which, ReplacementTarget.left);

      final rightFirst = LensesPairDatesModel(
        left: LensDateModel(dateStart: DateTime(2026), dateEnd: later, daysLeft: 1),
        right: LensDateModel(dateStart: DateTime(2026), dateEnd: earlier, daysLeft: 1),
      );
      expect(nextLensReplacement(rightFirst)!.which, ReplacementTarget.right);
    });
  });
}
