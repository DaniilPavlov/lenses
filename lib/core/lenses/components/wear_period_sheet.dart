import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lenses/common/utils/theme/const_colors_styles.dart';
import 'package:lenses/common/utils/theme/const_text_styles.dart';
import 'package:lenses/common/widgets/buttons/custom_button.dart';
import 'package:lenses/core/lenses/loaders/lens_wear_period_loader.dart';
import 'package:lenses/l10n/app_localizations.dart';

/// Bottom sheet выбора общего срока ношения линз (в днях).
class WearPeriodSheet extends StatefulWidget {
  const WearPeriodSheet({
    required this.initialDays,
    required this.onConfirmed,
    super.key,
  });

  final int initialDays;
  final ValueChanged<int> onConfirmed;

  @override
  State<WearPeriodSheet> createState() => _WearPeriodSheetState();
}

class _WearPeriodSheetState extends State<WearPeriodSheet> {
  late int _selectedDays;
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedDays = widget.initialDays.clamp(
      LensWearPeriodLoader.minDays,
      LensWearPeriodLoader.maxDays,
    );
    _scrollController = FixedExtentScrollController(
      initialItem: _selectedDays - LensWearPeriodLoader.minDays,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemCount = LensWearPeriodLoader.maxDays - LensWearPeriodLoader.minDays + 1;

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 30),
                      child: Text(
                        l10n.wearPeriodTitle,
                        style: AppTextStyles.heading.kH1,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        l10n.cancel,
                        style: AppTextStyles.heading.kH3,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 180,
                child: CupertinoPicker(
                  scrollController: _scrollController,
                  itemExtent: 40,
                  magnification: 1.1,
                  useMagnifier: true,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _selectedDays = LensWearPeriodLoader.minDays + index;
                    });
                  },
                  children: [
                    for (var i = 0; i < itemCount; i++)
                      Center(
                        child: Text(
                          l10n.wearPeriodDays(LensWearPeriodLoader.minDays + i),
                          style: AppTextStyles.heading.kH2,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                color: AppColors.pureColors.blue.b900,
                text: l10n.choose,
                onPressed: () {
                  widget.onConfirmed(_selectedDays);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
