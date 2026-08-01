import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/common/utils/theme/const_colors_styles.dart';
import 'package:lenses/common/widgets/buttons/custom_button.dart';
import 'package:lenses/core/lenses/components/put_on_end_sheet.dart';
import 'package:lenses/l10n/app_localizations_en.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('CustomButton invokes onPressed', (tester) async {
    var tapped = false;
    await tester.pumpApp(
      CustomButton(
        text: 'Go',
        color: AppColors.pureColors.green.g900,
        onPressed: () => tapped = true,
      ),
    );
    await tester.tap(find.text('Go'));
    expect(tapped, isTrue);

    await tester.pumpApp(
      CustomButton(
        text: 'White',
        color: AppColors.pureColors.white.o100,
        onPressed: () {},
      ),
    );
    expect(find.text('White'), findsOneWidget);
  });

  testWidgets('PutOnEndSheet callbacks and cancel', (tester) async {
    var left = false;
    var right = false;
    var both = false;
    await tester.pumpApp(
      PutOnEndSheet(
        onLeftConfirmed: () => left = true,
        onRightConfirmed: () => right = true,
        onBothConfirmed: () => both = true,
      ),
    );

    await tester.tap(find.text(AppLocalizationsEn().rightLensShort));
    expect(right, isTrue);
    await tester.tap(find.text(AppLocalizationsEn().bothLenses));
    expect(both, isTrue);
    await tester.tap(find.text(AppLocalizationsEn().leftLensShort));
    expect(left, isTrue);
    await tester.tap(find.text(AppLocalizationsEn().cancel));
    await tester.pumpAndSettle();
  });
}
