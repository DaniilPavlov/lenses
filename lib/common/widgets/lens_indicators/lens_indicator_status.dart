import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lenses/common/utils/theme/const_colors_styles.dart';
import 'package:lenses/common/utils/theme/const_text_styles.dart';
import 'package:lenses/l10n/app_localizations.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

/// Круговой индикатор оставшихся дней до замены линзы.
class LensIndicatorStatus extends StatelessWidget {
  const LensIndicatorStatus({
    required this.daysBeforeReplacement,
    required this.onUpdateTap,
    required this.lifeTime,
    this.title = true,
    this.isLeft = false,
    this.sameTime = false,
    this.isAloneChildCircle = false,
    super.key,
  });
  final int daysBeforeReplacement;
  final int lifeTime;
  final VoidCallback onUpdateTap;
  final bool title;
  final bool sameTime;
  final bool isAloneChildCircle;
  final bool isLeft;

  String _lensLabel(AppLocalizations l10n) {
    if (sameTime) {
      return l10n.semanticBothLenses;
    }
    return isLeft ? l10n.semanticLeftLens : l10n.semanticRightLens;
  }

  String _statusLabel(AppLocalizations l10n) {
    if (daysBeforeReplacement > 0) {
      return l10n.semanticDaysUntilReplacement(daysBeforeReplacement);
    }
    if (daysBeforeReplacement == 0) {
      return l10n.replacementDay;
    }
    return l10n.replacementDayOverdue;
  }

  String _actionLabel(AppLocalizations l10n) {
    return sameTime ? l10n.semanticReplaceLenses : l10n.semanticReplaceLens;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isActionable = daysBeforeReplacement <= 0;
    final status = isActionable ? _actionLabel(l10n) : _statusLabel(l10n);
    final semanticLabel = l10n.semanticLensStatus(_lensLabel(l10n), status);

    return Semantics(
      container: true,
      button: isActionable,
      label: semanticLabel,
      onTap: isActionable ? onUpdateTap : null,
      child: ExcludeSemantics(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            if (daysBeforeReplacement > 0)
              CircularPercentIndicator(
                header: title
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Text(
                          l10n.daysUntilReplacement,
                          style: AppTextStyles.heading.kH2,
                        ),
                      )
                    : const SizedBox(height: 8),
                radius: title ? 85 : 65,
                animation: true,
                animationDuration: 2000,
                lineWidth: 15,
                linearGradient: sameTime
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        transform: const GradientRotation(-2 * pi / 3),
                        colors: [
                          AppColors.pureColors.green.g100,
                          AppColors.pureColors.blue.b800,
                        ],
                      )
                    : null,
                percent: (daysBeforeReplacement >= lifeTime ? 1 : daysBeforeReplacement / lifeTime).toDouble(),
                center: Padding(
                  padding: EdgeInsets.only(top: isAloneChildCircle ? 10 : 7),
                  child: Text(
                    daysBeforeReplacement.toString(),
                    style: title ? AppTextStyles.heading.kH1 : AppTextStyles.heading.kH2,
                  ),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: AppColors.pureColors.bgMain.third,
                progressColor: sameTime
                    ? null
                    : isLeft
                        ? AppColors.pureColors.blue.b800
                        : AppColors.pureColors.green.g100,
              )
            else
              GestureDetector(
                onTap: onUpdateTap,
                child: !title
                    ? SizedBox(
                        height: 145,
                        width: 145,
                        child: Center(
                          child: Container(
                            height: 130,
                            width: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.pureColors.error.error,
                            ),
                            child: Center(
                              child: Text(
                                l10n.replaceLens,
                                style: AppTextStyles.heading.kH2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                daysBeforeReplacement == 0 ? l10n.replacementDay : l10n.replacementDayOverdue,
                                style: AppTextStyles.heading.kH2,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              height: 177,
                              width: 177,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.pureColors.error.error,
                              ),
                              child: Center(
                                child: Text(
                                  sameTime ? l10n.replaceLenses : l10n.replaceLens,
                                  style: AppTextStyles.heading.kH2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            if (!sameTime)
              Padding(
                padding: EdgeInsets.only(top: !isAloneChildCircle ? 0 : 30),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: 33,
                    width: 33,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                      color: isLeft ? AppColors.pureColors.blue.b800 : AppColors.pureColors.green.g100,
                    ),
                    child: Center(
                      child: Text(isLeft ? 'L' : 'R', style: AppTextStyles.heading.kH2),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
