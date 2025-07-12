import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lenses/controllers/lenses_controller.dart';
import 'package:lenses/widgets/lines/date_info_line.dart';
import 'package:lenses/widgets/lens_indicators/lens_indicator_status.dart';
import 'package:lenses/widgets/sheets/different_lenses_sheet.dart';
import 'package:lenses/styles/const_colors_styles.dart';
import 'package:lenses/styles/const_text_styles.dart';
import 'package:lenses/widgets/buttons/custom_button.dart';
import 'package:provider/provider.dart';

class TwoLensReplacementIndicator extends StatelessWidget {
  const TwoLensReplacementIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final controller = context.read<LensesController>();
        final leftLensDate = controller.pairDates.value?.left;
        final rightLensDate = controller.pairDates.value?.right;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Дней до замены',
                style: AppTextStyles.heading.kH2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: LensIndicatorStatus(
                        isLeft: true,
                        lifeTime: 14,
                        daysBeforeReplacement: leftLensDate!.daysLeft,
                        title: false,
                        onUpdateTap: () => controller.updateLensesPair(
                          leftDate: DateTime.now(),
                          rightDate: rightLensDate?.dateStart,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LensIndicatorStatus(
                        lifeTime: 14,
                        daysBeforeReplacement: rightLensDate!.daysLeft,
                        title: false,
                        onUpdateTap: () => controller.updateLensesPair(
                          leftDate: leftLensDate.dateStart,
                          rightDate: DateTime.now(),
                        ),
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
                        text: 'Редактировать',
                        color: AppColors.pureColors.black.o24,
                        onPressed: () {
                          showModalBottomSheet<num>(
                            isScrollControlled: true,
                            context: context,
                            barrierColor: Colors.black.withValues(alpha: 0.8),
                            builder: (context) {
                              return DifferentLensesSheet(
                                onConfirmed: ({leftDate, rightDate}) {
                                  controller.updateLensesPair(
                                    leftDate: leftDate,
                                    rightDate: rightDate,
                                  );
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
                      text: 'Завершить',
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
