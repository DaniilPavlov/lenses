import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lenses/widgets/lines/dotted_line.dart';
import 'package:lenses/controllers/lenses_controller.dart';
import 'package:lenses/styles/const_colors_styles.dart';
import 'package:lenses/styles/const_text_styles.dart';
import 'package:lenses/utils/utils.dart';
import 'package:provider/provider.dart';

class DateInfoLine extends StatelessWidget {
  const DateInfoLine({
    this.isLeft = true,
    this.hasIcon = true,
    super.key,
  });
  final bool hasIcon;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        final controller = context.read<LensesController>();
        final pairDates = controller.pairDates.value;
        final leftLensDate = pairDates?.left;
        final rightLensDate = pairDates?.right;
        final actualDateStart = isLeft ? leftLensDate!.dateStart : rightLensDate!.dateStart;
        final actualDateEnd = isLeft ? leftLensDate!.dateEnd : rightLensDate!.dateEnd;
        final actualDaysLeft = isLeft ? leftLensDate!.daysLeft : rightLensDate!.daysLeft;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasIcon)
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 17,
                      width: 17,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLeft ? AppColors.pureColors.blue.b800 : AppColors.pureColors.green.g100,
                      ),
                      child: Center(
                        child: Text(isLeft ? 'L' : 'R', style: AppTextStyles.body.kt1),
                      ),
                    ),
                  ),
                if (hasIcon) const SizedBox(width: 6),
                Text(
                  '${actualDateStart.day} ${Utils.getMonthNameByNumber(actualDateStart.month)}',
                  style: AppTextStyles.body.kt1s,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: DottedLine(
                lineLength: MediaQuery.of(context).size.width / 3,
                dashColor: AppColors.pureColors.black.o24,
                dashLength: 2,
                dashGapLength: 2,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${Utils.weekday(actualDateEnd)}, ${actualDateEnd.day} ${Utils.getMonthNameByNumber(actualDateEnd.month)}',
                  style: AppTextStyles.body.kt1s,
                ),
                if (actualDaysLeft < 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Text(
                      '${actualDaysLeft.toString().replaceFirst('-', '+ ')} д',
                      style: AppTextStyles.body.kt1.copyWith(
                        color: AppColors.pureColors.error.error,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}
