import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:lenses/common/utils/theme/const_colors_styles.dart';
import 'package:lenses/common/utils/theme/const_text_styles.dart';
import 'package:lenses/common/widgets/lines/dotted_line.dart';
import 'package:lenses/core/lenses/controllers/lenses_controller/lenses_controller.dart';
import 'package:lenses/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

/// Строка с датой начала/окончания ношения и просрочкой.
class DateInfoLine extends StatelessWidget {
  const DateInfoLine({this.isLeft = true, this.hasIcon = true, super.key});
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
        final lensDate = isLeft ? leftLensDate : rightLensDate;

        if (lensDate == null) {
          return const SizedBox.shrink();
        }

        final l10n = AppLocalizations.of(context);
        final locale = Localizations.localeOf(context).toString();
        final startLabel = DateFormat('d MMM', locale).format(lensDate.dateStart);
        final endLabel =
            '${DateFormat.E(locale).format(lensDate.dateEnd)}, ${DateFormat('d MMM', locale).format(lensDate.dateEnd)}';
        final lensLabel = isLeft ? l10n.semanticLeftLens : l10n.semanticRightLens;
        final semanticLabel = l10n.semanticWearPeriod(lensLabel, startLabel, endLabel);

        return Semantics(
          container: true,
          label: semanticLabel,
          child: ExcludeSemantics(
            child: SizedBox(
              width: double.infinity,
              child: Row(
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
                            child: Center(child: Text(isLeft ? 'L' : 'R', style: AppTextStyles.body.kt1)),
                          ),
                        ),
                      if (hasIcon) const SizedBox(width: 6),
                      Text(startLabel, style: AppTextStyles.body.kt1s),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return DottedLine(
                            lineLength: constraints.maxWidth,
                            dashColor: AppColors.pureColors.black.o24,
                            dashLength: 2,
                            dashGapLength: 2,
                          );
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(endLabel, style: AppTextStyles.body.kt1s),
                      if (lensDate.daysLeft < 0)
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text(
                            l10n.daysOverdue(lensDate.daysLeft.toString().replaceFirst('-', '+ ')),
                            style: AppTextStyles.body.kt1.copyWith(color: AppColors.pureColors.error.error),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
