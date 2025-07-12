import 'dart:ui';

// TODO придумать как сделать такой вызов рабочим
/// ```dart
///   const value = AppColors.pureColors.pink.p900
/// ```
class AppColors {
  AppColors._();

  static const pureColors = _PureColors();
}

class _PureColors {
  const _PureColors();

  final pink = const _PinkColors();
  final blue = const _BlueColors();
  final purple = const _PurpleColors();
  final yellow = const _YellowColors();
  final green = const _GreenColors();
  final white = const _WhiteColors();
  final black = const _BlackColors();
  final bgMain = const _BgMainColors();
  final error = const _ErrorColors();
}

class _PinkColors {
  const _PinkColors();

  final p900 = const Color(0xFFEB448C);
  final p700 = const Color(0xFFFF78B2);
  final p500 = const Color(0xFFFAAFDE);
  final p300 = const Color(0xFFF7C8E8);
  final p200 = const Color(0xFFF5D0EB);
  final p100 = const Color(0xFFF7E6F2);
}

class _BlueColors {
  const _BlueColors();

  final b900 = const Color(0xFF4EB2F5);
  final b800 = const Color(0xFF74C3F7);
  final b700 = const Color(0xFFA8D5F7);
  final b500 = const Color(0xFFBCDCF7);
  final b100 = const Color(0xFFD0E4F7);
}

class _PurpleColors {
  const _PurpleColors();

  final u900 = const Color(0xFF9C82D1);
  final u700 = const Color(0xFFB49DE3);
  final u600 = const Color(0xFFBEA9E7);
  final u500 = const Color(0xFFC9B5EB);
  final u300 = const Color(0xFFDACCF0);
  final u200 = const Color(0xFFE2D8F0);
  final u100 = const Color(0xFFE6DFF0);
  final u50 = const Color(0xFFEFECF3);
}

class _YellowColors {
  const _YellowColors();

  final y900 = const Color(0xFFFFB626);
  final y500 = const Color(0xFFF7E152);
  final y300 = const Color(0xFFF7EC77);
  final y200 = const Color(0xFFFFF0D4);
  final y100 = const Color(0xFFFFFFA4);
}

class _GreenColors {
  const _GreenColors();

  final g900 = const Color(0xFF9CD05A);
  final g500 = const Color(0xFFBEE472);
  final g100 = const Color(0xFFDBF598);
}

class _WhiteColors {
  const _WhiteColors();

  final o100 = const Color(0xFFFFFFFF);
  final o92 = const Color(0xEBFFFFFF); // 0.92 * 255 = 235 = 0xEB
  final o64 = const Color(0xA3FFFFFF); // 0.64 * 255 = 163 = 0xA3
  final o40 = const Color(0x66FFFFFF); // 0.40 * 255 = 102 = 0x66
  final o16 = const Color(0x16FFFFFF); // 0.16 * 255 = 255 = 0x16
}

class _BlackColors {
  const _BlackColors();

  final o100 = const Color(0xFF131413);
  final o64 = const Color(0xA3131413); // 0.64 * 255 = 163 ≈ 0xA3
  final o48 = const Color(0x7A131413); // 0.48 * 255 = 122 ≈ 0x7A
  final o24 = const Color(0x3D131413); // 0.24 * 255 = 61 ≈ 0x3D
  final o12 = const Color(0x1F131413); // 0.12 * 255 = 31 ≈ 0x1F
  final o08 = const Color(0x14131413); // 0.08 * 255 = 20 ≈ 0x14
  final o06 = const Color(0x0F131413); // 0.06 * 255 = 15 ≈ 0x0F
  final o05 = const Color(0x0D131413); // 0.05 * 255 = 13 ≈ 0x0D
  final o04 = const Color(0x0B131413); // 0.04 * 255 = 11 ≈  0x0B
}

class _BgMainColors {
  const _BgMainColors();

  final third = const Color(0xFFE5DFE1);
  final second = const Color(0xFFEDE8EA);
  final first = const Color(0xFFF5F2F3);
}

class _ErrorColors {
  const _ErrorColors();

  final error = const Color(0xFFD10046);
  final alertBg = const Color(0xFFFFE0E0);
  final alertText = const Color(0xFFFC5236);
}
