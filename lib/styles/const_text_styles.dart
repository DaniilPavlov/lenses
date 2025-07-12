import 'package:flutter/painting.dart';
import 'package:lenses/assets_gen/fonts.gen.dart';
import 'package:lenses/styles/const_colors_styles.dart';

class AppTextStyles {
  AppTextStyles._();

  static final heading = _HeadingStyle();
  static final body = _BodyStyle();
}

class _HeadingStyle {
  final kH1 = TextStyle(
    fontFamily: FontFamily.coolvetica,
    fontWeight: FontWeight.w400,
    color: AppColors.pureColors.black.o100,
    fontSize: 30,
    // при line-height = 28
    // height = 28 / 30 = 0.93
    height: 0.93,
    // при letter-spacing = 2
    // letterSpacing = 30 / 100 * 2 = 0.6
    letterSpacing: 0.6,
  );

  final kH2 = TextStyle(
    fontFamily: FontFamily.coolvetica,
    fontWeight: FontWeight.w400,
    color: AppColors.pureColors.black.o100,
    fontSize: 21,
    height: 0.95,
    letterSpacing: 0.42,
  );

  final kH3 = TextStyle(
    fontFamily: FontFamily.coolvetica,
    fontWeight: FontWeight.w400,
    color: AppColors.pureColors.black.o100,
    fontSize: 17,
    height: 1.05,
    letterSpacing: 0.34,
  );
}

class _BodyStyle {
  final kt1 = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w400,
    color: AppColors.pureColors.black.o100,
    fontSize: 14,
    height: 1.14,
    letterSpacing: 0.07,
  );

  final kt2 = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w400,
    color: AppColors.pureColors.black.o100,
    fontSize: 13,
    height: 1.07,
  );

  final kt3 = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w400,
    color: AppColors.pureColors.black.o100,
    fontSize: 12,
    height: 1.16,
  );

  final kt4 = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w400,
    color: AppColors.pureColors.black.o100,
    fontSize: 10,
    height: 1.4,
  );

  final kt1s = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w600,
    color: AppColors.pureColors.black.o100,
    fontSize: 14,
    height: 1,
  );

  final kt2s = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w600,
    color: AppColors.pureColors.black.o100,
    fontSize: 13,
    height: 1.07,
  );

  final kt3s = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w600,
    color: AppColors.pureColors.black.o100,
    fontSize: 12,
    height: 1.16,
  );

  final kt4s = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w600,
    color: AppColors.pureColors.black.o100,
    fontSize: 10,
    height: 1,
  );

  final kt1si = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: AppColors.pureColors.black.o100,
    fontSize: 14,
    height: 1,
  );

  final kt2si = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: AppColors.pureColors.black.o100,
    fontSize: 13,
    height: 1.07,
  );

  final kt3si = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: AppColors.pureColors.black.o100,
    fontSize: 12,
    height: 1.16,
  );

  final kt4i = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: AppColors.pureColors.black.o100,
    fontSize: 10,
    height: 1,
  );

  final kt3bi = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    color: AppColors.pureColors.black.o100,
    fontSize: 12,
    height: 1,
    letterSpacing: -0.24,
  );

  final kt4bi = TextStyle(
    fontFamily: FontFamily.rfDewi,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    color: AppColors.pureColors.black.o100,
    fontSize: 10,
    height: 1,
  );
}
