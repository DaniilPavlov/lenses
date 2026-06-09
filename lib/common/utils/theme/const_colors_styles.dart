import 'dart:ui';

// TODO(think): think how to make usage below possible
/// ```dart
///   const value = AppColors.pureColors.pink.p900
/// ```
class AppColors {
  AppColors._();

  static const pureColors = _PureColors();
}

class _PureColors {
  const _PureColors();

  _PinkColors get pink => const _PinkColors();
  _BlueColors get blue => const _BlueColors();
  _PurpleColors get purple => const _PurpleColors();
  _YellowColors get yellow => const _YellowColors();
  _GreenColors get green => const _GreenColors();
  _WhiteColors get white => const _WhiteColors();
  _BlackColors get black => const _BlackColors();
  _BgMainColors get bgMain => const _BgMainColors();
  _ErrorColors get error => const _ErrorColors();
}

class _PinkColors {
  const _PinkColors();

  Color get p900 => const Color(0xFFEB448C);
  Color get p700 => const Color(0xFFFF78B2);
  Color get p500 => const Color(0xFFFAAFDE);
  Color get p300 => const Color(0xFFF7C8E8);
  Color get p200 => const Color(0xFFF5D0EB);
  Color get p100 => const Color(0xFFF7E6F2);
}

class _BlueColors {
  const _BlueColors();

  Color get b900 => const Color(0xFF4EB2F5);
  Color get b800 => const Color(0xFF74C3F7);
  Color get b700 => const Color(0xFFA8D5F7);
  Color get b500 => const Color(0xFFBCDCF7);
  Color get b100 => const Color(0xFFD0E4F7);
}

class _PurpleColors {
  const _PurpleColors();

  Color get u900 => const Color(0xFF9C82D1);
  Color get u700 => const Color(0xFFB49DE3);
  Color get u600 => const Color(0xFFBEA9E7);
  Color get u500 => const Color(0xFFC9B5EB);
  Color get u300 => const Color(0xFFDACCF0);
  Color get u200 => const Color(0xFFE2D8F0);
  Color get u100 => const Color(0xFFE6DFF0);
  Color get u50 => const Color(0xFFEFECF3);
}

class _YellowColors {
  const _YellowColors();

  Color get y900 => const Color(0xFFFFB626);
  Color get y500 => const Color(0xFFF7E152);
  Color get y300 => const Color(0xFFF7EC77);
  Color get y200 => const Color(0xFFFFF0D4);
  Color get y100 => const Color(0xFFFFFFA4);
}

class _GreenColors {
  const _GreenColors();

  Color get g900 => const Color(0xFF9CD05A);
  Color get g500 => const Color(0xFFBEE472);
  Color get g100 => const Color(0xFFDBF598);
}

class _WhiteColors {
  const _WhiteColors();

  Color get o100 => const Color(0xFFFFFFFF);
  Color get o92 => const Color(0xEBFFFFFF); // 0.92 * 255 = 235 = 0xEB
  Color get o64 => const Color(0xA3FFFFFF); // 0.64 * 255 = 163 = 0xA3
  Color get o40 => const Color(0x66FFFFFF); // 0.40 * 255 = 102 = 0x66
  Color get o16 => const Color(0x16FFFFFF); // 0.16 * 255 = 255 = 0x16
}

class _BlackColors {
  const _BlackColors();

  Color get o100 => const Color(0xFF131413);
  Color get o64 => const Color(0xA3131413); // 0.64 * 255 = 163 ≈ 0xA3
  Color get o48 => const Color(0x7A131413); // 0.48 * 255 = 122 ≈ 0x7A
  Color get o24 => const Color(0x3D131413); // 0.24 * 255 = 61 ≈ 0x3D
  Color get o12 => const Color(0x1F131413); // 0.12 * 255 = 31 ≈ 0x1F
  Color get o08 => const Color(0x14131413); // 0.08 * 255 = 20 ≈ 0x14
  Color get o06 => const Color(0x0F131413); // 0.06 * 255 = 15 ≈ 0x0F
  Color get o05 => const Color(0x0D131413); // 0.05 * 255 = 13 ≈ 0x0D
  Color get o04 => const Color(0x0B131413); // 0.04 * 255 = 11 ≈  0x0B
}

class _BgMainColors {
  const _BgMainColors();

  Color get third => const Color(0xFFE5DFE1);
  Color get second => const Color(0xFFEDE8EA);
  Color get first => const Color(0xFFF5F2F3);
}

class _ErrorColors {
  const _ErrorColors();

  Color get error => const Color(0xFFD10046);
  Color get alertBg => const Color(0xFFFFE0E0);
  Color get alertText => const Color(0xFFFC5236);
}
