import 'package:flutter/material.dart';
import 'package:lenses/styles/const_colors_styles.dart';
import 'package:lenses/styles/const_text_styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.text,
    this.onPressed,
    required this.color,
    this.width,
    super.key,
  });
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.all(18),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.heading.kH2.copyWith(
            color: color == AppColors.pureColors.white.o100
                ? AppColors.pureColors.black.o48
                : AppColors.pureColors.white.o100,
          ),
        ),
      ),
    );
  }
}
