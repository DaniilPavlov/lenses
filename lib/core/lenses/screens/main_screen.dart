import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:lenses/common/utils/helpers/utils.dart';
import 'package:lenses/common/utils/theme/const_colors_styles.dart';
import 'package:lenses/common/utils/theme/const_text_styles.dart';
import 'package:lenses/common/widgets/app_bar/custom_app_bar.dart';
import 'package:lenses/common/widgets/buttons/custom_button.dart';
import 'package:lenses/common/widgets/lens_indicators/one_lens_replacement_indicator.dart';
import 'package:lenses/common/widgets/lens_indicators/two_lens_replacement_indicator.dart';
import 'package:lenses/core/lenses/components/different_lenses_sheet.dart';
import 'package:lenses/core/lenses/controllers/lenses_controller/lenses_controller.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const String id = 'main';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Text('Мои линзы', style: AppTextStyles.heading.kH1)),
      body: Center(
        child: Observer(
          builder: (context) {
            final controller = context.read<LensesController>();
            final pairDates = controller.pairDates.value;
            if (pairDates == null || pairDates.isEmpty) {
              return const _InitialWidget();
            }
            if (pairDates.hasBoth) {
              final leftLensDate = pairDates.left!;
              final rightLensDate = pairDates.right!;
              return leftLensDate.dateEnd.isSameDate(rightLensDate.dateEnd)
                  ? OneLensReplacementIndicator(sameTime: true, activeLensDate: leftLensDate)
                  : const TwoLensReplacementIndicator();
            }
            return OneLensReplacementIndicator(
              isLeft: pairDates.left != null,
              activeLensDate: pairDates.left ?? pairDates.right!,
            );
          },
        ),
      ),
    );
  }
}

class _InitialWidget extends StatelessWidget {
  const _InitialWidget();

  @override
  Widget build(BuildContext context) {
    final controller = context.read<LensesController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: CustomButton(
        width: MediaQuery.sizeOf(context).width,
        text: 'Надеть',
        color: AppColors.pureColors.green.g900,
        onPressed: () => _showLensesSheet(context, controller),
      ),
    );
  }

  void _showLensesSheet(BuildContext context, LensesController controller) {
    final pairDates = controller.pairDates.value;
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.8),
      builder: (context) {
        return DifferentLensesSheet(
          leftDate: pairDates?.left?.dateStart ?? DateTime.now(),
          rightDate: pairDates?.right?.dateStart ?? DateTime.now(),
          onConfirmed: ({leftDate, rightDate}) {
            controller.updateLensesPair(leftDate: leftDate, rightDate: rightDate);
          },
        );
      },
    );
  }
}
