import 'package:flutter/material.dart';
import 'package:lenses/assets_gen/assets.gen.dart';
import 'package:lenses/styles/const_colors_styles.dart';
import 'package:lenses/widgets/custom_svg_picture.dart';

/// Кнопка для перехода назад по стеку навигации на манер [BackButton]
class AppBarLeadingBackArrow extends StatelessWidget {
  const AppBarLeadingBackArrow({
    super.key,
    this.onPressed,
    this.backgroundColor,
  });

  final Function()? onPressed;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          } else {
            Navigator.maybePop(context);
          }
        },
        icon: CustomSvgPicture(Assets.icons.arrowBackSmall.path),
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: CircleBorder(
            side: BorderSide(
              color: AppColors.pureColors.black.o12,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}
