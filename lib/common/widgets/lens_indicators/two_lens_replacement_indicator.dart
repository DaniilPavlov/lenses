import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lenses/common/utils/theme/const_colors_styles.dart';
import 'package:lenses/common/utils/theme/const_text_styles.dart';
import 'package:lenses/common/widgets/buttons/custom_button.dart';
import 'package:lenses/common/widgets/lens_indicators/lens_indicator_status.dart';
import 'package:lenses/common/widgets/lines/date_info_line.dart';
import 'package:lenses/core/lenses/components/different_lenses_sheet.dart';
import 'package:lenses/core/lenses/controllers/lenses_controller/lenses_controller.dart';
import 'package:lenses/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Индикатор двух линз с разными датами замены.
class TwoLensReplacementIndicator extends StatelessWidget {
  const TwoLensReplacementIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final controller = context.read<LensesController>();
        final pairDates = controller.pairDates.value;
        final leftLensDate = pairDates?.left;
        final rightLensDate = pairDates?.right;

        if (leftLensDate == null || rightLensDate == null) {
          return const SizedBox.shrink();
        }

        final l10n = AppLocalizations.of(context);

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.daysUntilReplacement, style: AppTextStyles.heading.kH2),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LensIndicatorStatus(
                        isLeft: true,
                        lifeTime: LensesControllerBase.lensWearingDays,
                        daysBeforeReplacement: leftLensDate.daysLeft,
                        title: false,
                        onUpdateTap: () => controller.renewLenses(left: true, right: false),
                      ),
                    ),
                    Expanded(
                      child: LensIndicatorStatus(
                        lifeTime: LensesControllerBase.lensWearingDays,
                        daysBeforeReplacement: rightLensDate.daysLeft,
                        title: false,
                        onUpdateTap: () => controller.renewLenses(left: false, right: true),
                      ),
                    ),
                  ],
                ),
              ),
              const DateInfoLine(),
              const SizedBox(height: 13),
              const DateInfoLine(isLeft: false),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 10,
                  children: [
                    if (leftLensDate.daysLeft >= 0 || rightLensDate.daysLeft >= 0)
                      CustomButton(
                        width: MediaQuery.sizeOf(context).width,
                        text: l10n.edit,
                        color: AppColors.pureColors.black.o24,
                        onPressed: () {
                          showModalBottomSheet<num>(
                            isScrollControlled: true,
                            context: context,
                            barrierColor: Colors.black.withValues(alpha: 0.8),
                            builder: (context) {
                              return DifferentLensesSheet(
                                onConfirmed: ({leftDate, rightDate}) {
                                  controller.updateLensesPair(leftDate: leftDate, rightDate: rightDate);
                                },
                                leftDate: leftLensDate.dateStart,
                                rightDate: rightLensDate.dateStart,
                              );
                            },
                          );
                        },
                      ),
                    CustomButton(
                      width: MediaQuery.sizeOf(context).width,
                      color: AppColors.pureColors.error.alertText,
                      text: l10n.finish,
                      onPressed: () => controller.putOffLensesSheet(context: context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
