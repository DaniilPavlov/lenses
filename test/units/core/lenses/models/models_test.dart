import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';

import '../../../../helpers/controller_fixtures.dart';

void main() {
  group('LensesPairDatesModel', () {
    test('isEmpty / hasBoth', () {
      expect(const LensesPairDatesModel().isEmpty, isTrue);
      expect(const LensesPairDatesModel().hasBoth, isFalse);
      expect(ControllerFixtures.pairDates.hasBoth, isTrue);
      expect(ControllerFixtures.pairDates.isEmpty, isFalse);
      expect(LensesPairDatesModel(left: ControllerFixtures.leftLensDate).hasBoth, isFalse);
    });

    test('json roundtrip', () {
      final json = ControllerFixtures.pairDates.toJson();
      final restored = LensesPairDatesModel.fromJson(json);
      expect(restored.left?.dateStart, ControllerFixtures.leftLensDate.dateStart);
      expect(restored.right?.daysLeft, ControllerFixtures.rightLensDate.daysLeft);
    });
  });

  group('LensDateModel', () {
    test('json roundtrip', () {
      final json = ControllerFixtures.leftLensDate.toJson();
      final restored = LensDateModel.fromJson(json);
      expect(restored.dateEnd, ControllerFixtures.leftLensDate.dateEnd);
      expect(restored.daysLeft, ControllerFixtures.leftLensDate.daysLeft);
    });
  });
}
