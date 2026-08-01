import 'package:flutter_test/flutter_test.dart';
import 'package:lenses/common/utils/theme/const_colors_styles.dart';
import 'package:lenses/common/utils/theme/const_text_styles.dart';

void main() {
  test('AppColors palette getters are reachable', () {
    final c = AppColors.pureColors;
    expect(c.pink.p900.a, isNonZero);
    expect(c.pink.p700.a, isNonZero);
    expect(c.pink.p500.a, isNonZero);
    expect(c.pink.p300.a, isNonZero);
    expect(c.pink.p200.a, isNonZero);
    expect(c.pink.p100.a, isNonZero);
    expect(c.blue.b900.a, isNonZero);
    expect(c.blue.b800.a, isNonZero);
    expect(c.blue.b700.a, isNonZero);
    expect(c.blue.b500.a, isNonZero);
    expect(c.blue.b100.a, isNonZero);
    expect(c.purple.u900.a, isNonZero);
    expect(c.purple.u700.a, isNonZero);
    expect(c.purple.u600.a, isNonZero);
    expect(c.purple.u500.a, isNonZero);
    expect(c.purple.u300.a, isNonZero);
    expect(c.purple.u200.a, isNonZero);
    expect(c.purple.u100.a, isNonZero);
    expect(c.purple.u50.a, isNonZero);
    expect(c.yellow.y900.a, isNonZero);
    expect(c.yellow.y500.a, isNonZero);
    expect(c.yellow.y300.a, isNonZero);
    expect(c.yellow.y200.a, isNonZero);
    expect(c.yellow.y100.a, isNonZero);
    expect(c.green.g900.a, isNonZero);
    expect(c.green.g500.a, isNonZero);
    expect(c.green.g100.a, isNonZero);
    expect(c.white.o100.a, isNonZero);
    expect(c.white.o92.a, isNonZero);
    expect(c.white.o64.a, isNonZero);
    expect(c.white.o40.a, isNonZero);
    expect(c.white.o16.a, isNonZero);
    expect(c.black.o100.a, isNonZero);
    expect(c.black.o64.a, isNonZero);
    expect(c.black.o48.a, isNonZero);
    expect(c.black.o24.a, isNonZero);
    expect(c.black.o12.a, isNonZero);
    expect(c.black.o08.a, isNonZero);
    expect(c.black.o06.a, isNonZero);
    expect(c.black.o05.a, isNonZero);
    expect(c.black.o04.a, isNonZero);
    expect(c.bgMain.third.a, isNonZero);
    expect(c.bgMain.second.a, isNonZero);
    expect(c.bgMain.first.a, isNonZero);
    expect(c.error.error.a, isNonZero);
    expect(c.error.alertBg.a, isNonZero);
    expect(c.error.alertText.a, isNonZero);
  });

  test('AppTextStyles getters are reachable', () {
    final styles = <Object>[
      AppTextStyles.heading.kH1,
      AppTextStyles.heading.kH2,
      AppTextStyles.heading.kH3,
      AppTextStyles.body.kt1,
      AppTextStyles.body.kt2,
      AppTextStyles.body.kt3,
      AppTextStyles.body.kt4,
      AppTextStyles.body.kt1s,
      AppTextStyles.body.kt2s,
      AppTextStyles.body.kt3s,
      AppTextStyles.body.kt4s,
      AppTextStyles.body.kt1si,
      AppTextStyles.body.kt2si,
      AppTextStyles.body.kt3si,
      AppTextStyles.body.kt4i,
      AppTextStyles.body.kt3bi,
      AppTextStyles.body.kt4bi,
    ];
    expect(styles, hasLength(17));
  });
}
