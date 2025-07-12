import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lenses/controllers/lenses_controller.dart';
import 'package:lenses/models/generated/generated.dart';
import 'package:lenses/widgets/lines/date_info_line.dart';
import 'package:lenses/widgets/lens_indicators/lens_indicator_status.dart';
import 'package:lenses/widgets/sheets/different_lenses_sheet.dart';
import 'package:lenses/widgets/sheets/put_on_date_sheet.dart';
import 'package:lenses/styles/const_colors_styles.dart';
import 'package:lenses/widgets/buttons/custom_button.dart';
import 'package:provider/provider.dart';

class OneLensReplacementIndicator extends StatelessWidget {
  final LensDateModel activeLensDate;
  final bool isLeft;
  final bool sameTime;

  const OneLensReplacementIndicator({
    required this.activeLensDate,
    this.isLeft = false,
    this.sameTime = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      final controller = context.read<LensesController>();
      final pairDates = controller.pairDates.value;
      final leftLensDate = pairDates?.left;
      final rightLensDate = pairDates?.right;
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: LensIndicatorStatus(
                sameTime: sameTime,
                isAloneChildCircle: true,
                isLeft: isLeft,
                lifeTime: 14,
                daysBeforeReplacement: activeLensDate.daysLeft,
                onUpdateTap: () {
                  controller.updateLensesPair(
                    leftDate: DateTime.now(),
                    rightDate: DateTime.now(),
                  );
                },
              ),
            ),
            DateInfoLine(
              isLeft: isLeft,
              hasIcon: !sameTime,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Column(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    spacing: 3,
                    children: [
                      if (activeLensDate.daysLeft >= 0)
                        Expanded(
                          flex: 3,
                          child: CustomButton(
                            text: 'Редактировать',
                            color: AppColors.pureColors.black.o24,
                            onPressed: () => _showEditSheet(
                              context,
                              controller,
                              leftLensDate,
                              rightLensDate,
                            ),
                          ),
                        ),
                      if (leftLensDate == null || rightLensDate == null)
                        Expanded(
                          flex: 2,
                          child: CustomButton(
                            text: 'Надеть',
                            color: AppColors.pureColors.green.g900,
                            onPressed: () => _showPutOnSheet(
                              context,
                              controller,
                              leftLensDate,
                              rightLensDate,
                            ),
                          ),
                        ),
                    ],
                  ),
                  CustomButton(
                    width: MediaQuery.sizeOf(context).width,
                    color: AppColors.pureColors.error.alertText,
                    text: activeLensDate.daysLeft >= 0 ? 'Завершить' : 'Завершить ношение',
                    onPressed: () => controller.putOffLensesSheet(context: context),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showEditSheet(
    BuildContext context,
    LensesController controller,
    LensDateModel? leftLensDate,
    LensDateModel? rightLensDate,
  ) {
    showModalBottomSheet<num>(
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) {
        if (sameTime) {
          return DifferentLensesSheet(
            onConfirmed: ({leftDate, rightDate}) {
              controller.updateLensesPair(
                leftDate: leftDate,
                rightDate: rightDate,
              );
            },
            leftDate: leftLensDate!.dateStart,
            rightDate: rightLensDate!.dateStart,
          );
        } else {
          return PutOnDateSheet(
            leftPut: leftLensDate?.dateStart,
            rightPut: rightLensDate?.dateStart,
            onConfirmed: ({leftDate, rightDate}) {
              controller.updateLensesPair(
                leftDate: leftDate,
                rightDate: rightDate,
              );
            },
          );
        }
      },
    );
  }

  void _showPutOnSheet(
    BuildContext context,
    LensesController controller,
    LensDateModel? leftLensDate,
    LensDateModel? rightLensDate,
  ) {
    showModalBottomSheet<num>(
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) {
        return (leftLensDate != null && rightLensDate == null) || (leftLensDate == null && rightLensDate != null)
            ? PutOnDateSheet(
                leftPut: leftLensDate?.dateStart != null ? null : DateTime.now(),
                rightPut: rightLensDate?.dateStart != null ? null : DateTime.now(),
                onConfirmed: ({
                  leftDate,
                  rightDate,
                }) =>
                    controller.updateLensesPair(
                  leftDate: leftDate,
                  rightDate: rightDate,
                ),
              )
            : DifferentLensesSheet(
                leftDate: leftLensDate?.dateStart ?? DateTime.now(),
                rightDate: rightLensDate?.dateStart ?? DateTime.now(),
                onConfirmed: ({
                  leftDate,
                  rightDate,
                }) =>
                    controller.updateLensesPair(
                  leftDate: leftDate,
                  rightDate: rightDate,
                ),
              );
      },
    );
  }
}
