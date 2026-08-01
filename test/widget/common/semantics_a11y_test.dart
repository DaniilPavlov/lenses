import 'dart:ui' show Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/common/localization/locale_controller.dart';
import 'package:lenses/common/widgets/app_bar/custom_app_bar.dart';
import 'package:lenses/common/widgets/lens_indicators/lens_indicator_status.dart';
import 'package:lenses/core/lenses/components/different_lenses_sheet.dart';
import 'package:lenses/core/lenses/controllers/lenses_controller/lenses_controller.dart';
import 'package:lenses/l10n/app_localizations_en.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/controller_fixtures.dart';
import '../../helpers/pump_app.dart';

void main() {
  final l10n = AppLocalizationsEn();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('LensIndicatorStatus exposes days-left semantics', (tester) async {
    await tester.pumpApp(
      LensIndicatorStatus(
        daysBeforeReplacement: 5,
        lifeTime: LensesControllerBase.defaultWearingDays,
        isLeft: true,
        onUpdateTap: () {},
      ),
    );

    final node = tester.getSemantics(find.byType(LensIndicatorStatus));
    expect(
      node.label,
      l10n.semanticLensStatus(
        l10n.semanticLeftLens,
        l10n.semanticDaysUntilReplacement(5),
      ),
    );
    expect(node.flagsCollection.isButton, isFalse);
  });

  testWidgets('LensIndicatorStatus exposes replace button semantics', (tester) async {
    var tapped = false;
    await tester.pumpApp(
      LensIndicatorStatus(
        daysBeforeReplacement: 0,
        lifeTime: LensesControllerBase.defaultWearingDays,
        sameTime: true,
        onUpdateTap: () => tapped = true,
      ),
    );

    final expectedLabel = l10n.semanticLensStatus(
      l10n.semanticBothLenses,
      l10n.semanticReplaceLenses,
    );
    final node = tester.getSemantics(find.bySemanticsLabel(expectedLabel));
    expect(node.label, expectedLabel);
    expect(node.flagsCollection.isButton, isTrue);

    await tester.tap(find.bySemanticsLabel(expectedLabel));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('DifferentLensesSheet L/R buttons have selected semantics', (tester) async {
    await tester.pumpApp(
      DifferentLensesSheet(
        leftDate: DateTime(2026, 6),
        rightDate: DateTime(2026, 6, 2),
        onConfirmed: ({leftDate, rightDate}) {},
      ),
    );

    final left = tester.getSemantics(find.bySemanticsLabel(l10n.semanticLeftLens));
    expect(left.flagsCollection.isButton, isTrue);
    expect(left.flagsCollection.isSelected, Tristate.isTrue);

    final right = tester.getSemantics(find.bySemanticsLabel(l10n.semanticRightLens));
    expect(right.flagsCollection.isButton, isTrue);
    expect(right.flagsCollection.isSelected, isNot(Tristate.isTrue));

    await tester.tap(find.bySemanticsLabel(l10n.semanticRightLens));
    await tester.pump();

    expect(
      tester.getSemantics(find.bySemanticsLabel(l10n.semanticRightLens)).flagsCollection.isSelected,
      Tristate.isTrue,
    );
  });

  testWidgets('AppBar locale toggle has switch-language semantics', (tester) async {
    final localeController = LocaleController();
    final lensesController = ControllerFixtures.controller()..loadLensesDates();
    await tester.pumpApp(
      const Scaffold(
        appBar: CustomAppBar(title: Text('Title')),
        body: SizedBox.shrink(),
      ),
      wrapInScaffold: false,
      wrapApp: (app) => MultiProvider(
        providers: [
          Provider<LocaleController>.value(value: localeController),
          Provider<LensesController>.value(value: lensesController),
        ],
        child: app,
      ),
    );

    final label = l10n.semanticToggleLocale(l10n.semanticLanguageEn);
    final node = tester.getSemantics(find.bySemanticsLabel(label));
    expect(node.label, label);
    expect(node.flagsCollection.isButton, isTrue);
  });
}
