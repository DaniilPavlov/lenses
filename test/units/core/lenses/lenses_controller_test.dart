import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/common/utils/helpers/mobx_async_value.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';

import '../../../helpers/controller_fixtures.dart';
import '../../../mobx/mobx_testing.dart';

void main() {
  group('LensesController', () {
    group('loadLensesDates', () {
      mobxTest(
        'sets value when stored data exists',
        build: () => ControllerFixtures.controller(loadPairDatesRaw: () => ControllerFixtures.pairDatesJson),
        value: (store) => store.pairDates,
        act: (store) => store.loadLensesDates(),
        expect: () => [
          isA<AsyncValue<LensesPairDatesModel?>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<LensesPairDatesModel?>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.left, 'left', isNotNull)
              .having((e) => e.value?.right, 'right', isNotNull),
        ],
      );

      mobxTest(
        'sets error on invalid json',
        build: () => ControllerFixtures.controller(loadPairDatesRaw: () => 'invalid-json'),
        value: (store) => store.pairDates,
        act: (store) => store.loadLensesDates(),
        expect: () => [
          isA<AsyncValue<LensesPairDatesModel?>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<LensesPairDatesModel?>>().having((e) => e.status, 'status', AsyncStatus.error),
        ],
        verify: (store) {
          expect(store.pairDates.error?.errorMessage, 'loadError');
        },
      );

      test('sets null value when storage is empty', () {
        final controller = ControllerFixtures.controller(loadPairDatesRaw: () => null)..loadLensesDates();

        expect(controller.pairDates.isValue, isTrue);
        expect(controller.pairDates.value, isNull);
      });

      test('sets null value when stored pair is empty', () {
        final controller = ControllerFixtures.controller(loadPairDatesRaw: () => '{"left":null,"right":null}')
          ..loadLensesDates();

        expect(controller.pairDates.value, isNull);
      });
    });

    group('updateLensesPair', () {
      mobxTest(
        'updates pair dates and saves json',
        build: ControllerFixtures.controller,
        value: (store) => store.pairDates,
        act: (store) => store.updateLensesPair(
          leftDate: ControllerFixtures.startDate,
          rightDate: ControllerFixtures.startDate.add(const Duration(days: 1)),
        ),
        expect: () => [
          isA<AsyncValue<LensesPairDatesModel?>>().having((e) => e.status, 'status', AsyncStatus.loading),
          isA<AsyncValue<LensesPairDatesModel?>>()
              .having((e) => e.status, 'status', AsyncStatus.value)
              .having((e) => e.value?.left?.dateStart, 'leftDateStart', ControllerFixtures.startDate)
              .having(
                (e) => e.value?.right?.dateStart,
                'rightDateStart',
                ControllerFixtures.startDate.add(const Duration(days: 1)),
              ),
        ],
      );
    });

    group('putOffLensesPair', () {
      test('removes left lens when left is true', () {
        final controller = ControllerFixtures.controller(loadPairDatesRaw: () => ControllerFixtures.pairDatesJson)
          ..loadLensesDates()
          ..putOffLensesPair(left: true, right: false);

        expect(controller.pairDates.value?.left, isNull);
        expect(controller.pairDates.value?.right, isNotNull);
      });

      test('removes right lens when right is true', () {
        final controller = ControllerFixtures.controller(loadPairDatesRaw: () => ControllerFixtures.pairDatesJson)
          ..loadLensesDates()
          ..putOffLensesPair(left: false, right: true);

        expect(controller.pairDates.value?.left, isNotNull);
        expect(controller.pairDates.value?.right, isNull);
      });

      test('clears storage when both lenses are removed', () async {
        var cleared = false;
        final controller =
            ControllerFixtures.controller(
                loadPairDatesRaw: () => ControllerFixtures.pairDatesJson,
                clearPairDatesRaw: () async => cleared = true,
              )
              ..loadLensesDates()
              ..putOffLensesPair(left: true, right: true);

        await Future<void>.delayed(Duration.zero);

        expect(controller.pairDates.value, isNull);
        expect(cleared, isTrue);
      });
    });

    group('renewLenses', () {
      test('renews only selected lenses', () {
        final controller = ControllerFixtures.controller(loadPairDatesRaw: () => ControllerFixtures.pairDatesJson)
          ..loadLensesDates();
        final previousRightStart = controller.pairDates.value!.right!.dateStart;

        controller.renewLenses(left: true, right: false);

        expect(controller.pairDates.value!.left!.dateStart, ControllerFixtures.fixedNow);
        expect(controller.pairDates.value!.right!.dateStart, previousRightStart);
      });
    });
  });
}
