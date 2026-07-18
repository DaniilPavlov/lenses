import 'package:flutter/material.dart';
import 'package:lenses/common/utils/theme/const_colors_styles.dart';
import 'package:lenses/common/utils/theme/const_text_styles.dart';
import 'package:lenses/common/widgets/buttons/custom_button.dart';
import 'package:lenses/l10n/app_localizations.dart';

/// Bottom sheet выбора, какую линзу (или обе) снять.
class PutOnEndSheet extends StatelessWidget {
  const PutOnEndSheet({
    required this.onBothConfirmed,
    required this.onLeftConfirmed,
    required this.onRightConfirmed,
    super.key,
  });
  final VoidCallback onLeftConfirmed;
  final VoidCallback onRightConfirmed;
  final VoidCallback onBothConfirmed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: ColoredBox(
        color: AppColors.pureColors.bgMain.third,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: 16,
            left: 16,
            bottom: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.pureColors.white.o100,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        l10n.finishWearing,
                        style: AppTextStyles.heading.kH1,
                      ),
                    ),
                    GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: Text(
                        l10n.cancel,
                        style: AppTextStyles.heading.kH3,
                      ),
                    ),
                  ],
                ),
              ),
              CustomButton(
                width: MediaQuery.sizeOf(context).width,
                color: AppColors.pureColors.white.o100,
                text: l10n.leftLensShort,
                onPressed: onLeftConfirmed,
              ),
              const SizedBox(height: 6),
              CustomButton(
                width: MediaQuery.sizeOf(context).width,
                color: AppColors.pureColors.white.o100,
                text: l10n.rightLensShort,
                onPressed: onRightConfirmed,
              ),
              const SizedBox(height: 6),
              CustomButton(
                width: MediaQuery.sizeOf(context).width,
                color: AppColors.pureColors.blue.b900,
                text: l10n.bothLenses,
                onPressed: onBothConfirmed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
