import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';
import 'package:lenses/services/widgets/lens_home_widget_payload.dart';

import '../../../helpers/controller_fixtures.dart';

void main() {
  group('mapPairDatesToWidgetState', () {
    test('empty for null or empty pair', () {
      expect(mapPairDatesToWidgetState(null).mode, LensHomeWidgetMode.empty);
      expect(mapPairDatesToWidgetState(const LensesPairDatesModel()).mode, LensHomeWidgetMode.empty);
    });

    test('single left only', () {
      final state = mapPairDatesToWidgetState(LensesPairDatesModel(left: ControllerFixtures.leftLensDate));
      expect(state.mode, LensHomeWidgetMode.single);
      expect(state.accent, LensHomeWidgetAccent.left);
      expect(state.leftEnd, '2026-01-15');
      expect(state.rightEnd, isEmpty);
    });

    test('single right only', () {
      final state = mapPairDatesToWidgetState(LensesPairDatesModel(right: ControllerFixtures.rightLensDate));
      expect(state.mode, LensHomeWidgetMode.single);
      expect(state.accent, LensHomeWidgetAccent.right);
      expect(state.leftEnd, isEmpty);
      expect(state.rightEnd, '2026-01-16');
    });

    test('single when both same end date', () {
      final end = DateTime(2026, 1, 15);
      final state = mapPairDatesToWidgetState(
        LensesPairDatesModel(
          left: LensDateModel(dateStart: DateTime(2026), dateEnd: end, daysLeft: 1),
          right: LensDateModel(dateStart: DateTime(2026), dateEnd: end, daysLeft: 1),
        ),
      );
      expect(state.mode, LensHomeWidgetMode.single);
      expect(state.accent, LensHomeWidgetAccent.both);
      expect(state.leftEnd, '2026-01-15');
      expect(state.rightEnd, '2026-01-15');
    });

    test('dual when ends differ', () {
      final state = mapPairDatesToWidgetState(ControllerFixtures.pairDates);
      expect(state.mode, LensHomeWidgetMode.dual);
      expect(state.leftEnd, '2026-01-15');
      expect(state.rightEnd, '2026-01-16');
    });
  });

  group('daysLeftUntil', () {
    test('counts days until dateEnd (0 on replacement day)', () {
      final end = DateTime(2026, 8, 15);
      // ignore: avoid_redundant_argument_values
      expect(daysLeftUntil(end, now: DateTime(2026, 8, 1)), 14);
      expect(daysLeftUntil(end, now: DateTime(2026, 8, 15)), 0);
      expect(daysLeftUntil(end, now: DateTime(2026, 8, 16)), -1);
    });
  });
}
