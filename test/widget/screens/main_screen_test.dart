import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:lenses/common/localization/locale_controller.dart';
import 'package:lenses/common/widgets/lens_indicators/one_lens_replacement_indicator.dart';
import 'package:lenses/common/widgets/lens_indicators/two_lens_replacement_indicator.dart';
import 'package:lenses/core/lenses/components/different_lenses_sheet.dart';
import 'package:lenses/core/lenses/components/put_on_date_sheet.dart';
import 'package:lenses/core/lenses/components/put_on_end_sheet.dart';
import 'package:lenses/core/lenses/controllers/lenses_controller/lenses_controller.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';
import 'package:lenses/core/lenses/screens/main_screen.dart';
import 'package:lenses/l10n/app_localizations_en.dart';
import 'package:lenses/services/notifications/lens_replacement_reminder_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';

String _pairJson({LensDateModel? left, LensDateModel? right}) =>
    json.encode(LensesPairDatesModel(left: left, right: right).toJson());

/// Dates relative to [ControllerFixtures.fixedNow] so recalculated daysLeft stay positive.
LensDateModel _freshLens({int startOffsetDays = -5, int daysLeft = 9}) {
  final start = ControllerFixtures.fixedNow.add(Duration(days: startOffsetDays));
  return LensDateModel(
    dateStart: start,
    dateEnd: start.add(const Duration(days: LensesControllerBase.defaultWearingDays)),
    daysLeft: daysLeft,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await GetIt.I.reset();
    GetIt.I.registerSingleton<LensReplacementReminderService>(LensReplacementReminderService());
  });

  tearDown(() async {
    await GetIt.I.reset();
  });

  Future<void> pumpMain(WidgetTester tester, LensesController controller) {
    return tester.pumpApp(
      const MainScreen(),
      wrapInScaffold: false,
      surfaceSize: const Size(430, 932),
      wrapApp: (app) => MultiProvider(
        providers: [
          Provider<LocaleController>(create: (_) => LocaleController()),
          Provider<LensesController>.value(value: controller),
        ],
        child: app,
      ),
    );
  }

  testWidgets('empty state shows put on and opens sheet', (tester) async {
    final controller = ControllerFixtures.controller()..loadLensesDates();
    await pumpMain(tester, controller);

    expect(find.text(AppLocalizationsEn().putOn), findsOneWidget);
    await tester.tap(find.text(AppLocalizationsEn().putOn));
    await tester.pumpAndSettle();

    expect(find.byType(DifferentLensesSheet), findsOneWidget);
    await tester.tap(find.text('R'));
    await tester.pumpAndSettle();
    await tester.tap(find.text(AppLocalizationsEn().choose));
    await tester.pumpAndSettle();
    expect(find.byType(DifferentLensesSheet), findsNothing);
    expect(controller.pairDates.value?.hasBoth, isTrue);
  });

  testWidgets('one lens shows OneLensReplacementIndicator and edit sheet', (tester) async {
    final lens = _freshLens();
    final controller = ControllerFixtures.controller(
      loadPairDatesRaw: () => _pairJson(left: lens),
    )..loadLensesDates();

    await pumpMain(tester, controller);
    expect(find.byType(OneLensReplacementIndicator), findsOneWidget);

    await tester.tap(find.text(AppLocalizationsEn().edit));
    await tester.pumpAndSettle();
    expect(find.byType(PutOnDateSheet), findsOneWidget);
    await tester.tap(find.text(AppLocalizationsEn().choose));
    await tester.pumpAndSettle();
  });

  testWidgets('one lens put on other opens PutOnDateSheet', (tester) async {
    final controller = ControllerFixtures.controller(
      loadPairDatesRaw: () => _pairJson(left: _freshLens()),
    )..loadLensesDates();

    await pumpMain(tester, controller);
    await tester.tap(find.text(AppLocalizationsEn().putOn));
    await tester.pumpAndSettle();
    expect(find.byType(PutOnDateSheet), findsOneWidget);
    await tester.tap(find.text(AppLocalizationsEn().cancel));
    await tester.pumpAndSettle();
  });

  testWidgets('both lenses different end dates show TwoLensReplacementIndicator', (tester) async {
    final controller = ControllerFixtures.controller(
      loadPairDatesRaw: () => _pairJson(
        left: _freshLens(),
        right: _freshLens(startOffsetDays: -2),
      ),
    )..loadLensesDates();

    await pumpMain(tester, controller);
    expect(find.byType(TwoLensReplacementIndicator), findsOneWidget);
  });

  testWidgets('both lenses same end date show OneLensReplacementIndicator', (tester) async {
    final same = _freshLens();
    final controller = ControllerFixtures.controller(
      loadPairDatesRaw: () => _pairJson(left: same, right: same),
    )..loadLensesDates();

    await pumpMain(tester, controller);
    expect(find.byType(OneLensReplacementIndicator), findsOneWidget);

    await tester.tap(find.text(AppLocalizationsEn().edit));
    await tester.pumpAndSettle();
    expect(find.byType(DifferentLensesSheet), findsOneWidget);
    await tester.tap(find.text(AppLocalizationsEn().cancel));
    await tester.pumpAndSettle();
  });

  testWidgets('finish opens PutOnEndSheet when both worn', (tester) async {
    final controller = ControllerFixtures.controller(
      loadPairDatesRaw: () => _pairJson(
        left: _freshLens(),
        right: _freshLens(startOffsetDays: -2),
      ),
    )..loadLensesDates();

    await pumpMain(tester, controller);
    await tester.tap(find.text(AppLocalizationsEn().finish));
    await tester.pumpAndSettle();
    expect(find.byType(PutOnEndSheet), findsOneWidget);

    await tester.tap(find.text(AppLocalizationsEn().leftLensShort));
    await tester.pumpAndSettle();
    expect(controller.pairDates.value?.left, isNull);
    expect(controller.pairDates.value?.right, isNotNull);
  });

  testWidgets('overdue lens shows replace affordance', (tester) async {
    final overdue = LensDateModel(
      dateStart: ControllerFixtures.fixedNow.subtract(const Duration(days: 20)),
      dateEnd: ControllerFixtures.fixedNow.subtract(const Duration(days: 6)),
      daysLeft: -2,
    );
    final controller = ControllerFixtures.controller(
      loadPairDatesRaw: () => _pairJson(left: overdue),
    )..loadLensesDates();

    await pumpMain(tester, controller);
    expect(find.textContaining('Replace'), findsWidgets);
  });

  testWidgets('locale toggle updates label', (tester) async {
    final controller = ControllerFixtures.controller()..loadLensesDates();
    await pumpMain(tester, controller);

    expect(find.text('RU'), findsOneWidget);
    await tester.tap(find.text('RU'));
    await tester.pumpAndSettle();
    expect(find.text('EN'), findsOneWidget);
  });
}
