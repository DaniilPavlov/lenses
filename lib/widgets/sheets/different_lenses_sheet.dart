import 'package:flutter/material.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/flutter_cupertino_date_picker_fork.dart';
import 'package:lenses/styles/const_colors_styles.dart';
import 'package:lenses/styles/const_text_styles.dart';
import 'package:lenses/widgets/buttons/custom_button.dart';

class DifferentLensesSheet extends StatefulWidget {
  final void Function({DateTime? leftDate, DateTime? rightDate}) onConfirmed;
  final DateTime leftDate;
  final DateTime rightDate;
  const DifferentLensesSheet({
    required this.onConfirmed,
    required this.rightDate,
    required this.leftDate,
    super.key,
  });

  @override
  State<DifferentLensesSheet> createState() => _DifferentLensesSheetState();
}

class _DifferentLensesSheetState extends State<DifferentLensesSheet> {
  bool leftActive = true;
  late DateTime leftDate;
  late DateTime rightDate;

  @override
  void initState() {
    leftDate = widget.leftDate;
    rightDate = widget.rightDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior(),
      child: ClipRRect(
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
                    Padding(
                      padding: const EdgeInsets.only(top: 40, bottom: 30),
                      child: Text(
                        'Линзы надеты',
                        style: AppTextStyles.heading.kH1,
                      ),
                    ),
                    GestureDetector(
                      onTap: Navigator.of(context).pop,
                      child: Container(
                        color: Colors.transparent,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Отменить',
                          style: AppTextStyles.heading.kH3,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['L', 'R']
                      .map(
                        (type) => Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: 'L' == type && leftActive || 'R' == type && !leftActive
                                    ? AppColors.pureColors.blue.b800
                                    : Colors.white,
                                width: 2,
                              ),
                              color: Colors.white,
                            ),
                            child: InkWell(
                              splashFactory: NoSplash.splashFactory,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                setState(() {
                                  leftActive = !leftActive;
                                });
                              },
                              customBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 11, top: 9),
                                  child: Text(
                                    type,
                                    style: AppTextStyles.heading.kH2.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 10),
                if (leftActive)
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    clipBehavior: Clip.hardEdge,
                    child: DatePickerWidget(
                      key: const Key('L'),
                      onMonthChangeStartWithFirstDate: false,
                      initialDateTime: leftDate,
                      minDateTime: DateTime.now().subtract(const Duration(days: 15)),
                      maxDateTime: DateTime.now().add(const Duration(days: 5)),
                      locale: DateTimePickerLocale.ru,
                      pickerTheme: const DateTimePickerTheme(
                        cancel: SizedBox(),
                        confirm: SizedBox(),
                        titleHeight: 0,
                      ),
                      onChange: (value, _) {
                        leftDate = value;
                      },
                      dateFormat: 'dd.MM.yyyy',
                    ),
                  )
                else
                  Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                    clipBehavior: Clip.hardEdge,
                    child: DatePickerWidget(
                      key: const Key('R'),
                      onMonthChangeStartWithFirstDate: false,
                      initialDateTime: rightDate,
                      minDateTime: DateTime.now().subtract(const Duration(days: 15)),
                      maxDateTime: DateTime.now().add(const Duration(days: 5)),
                      locale: DateTimePickerLocale.ru,
                      pickerTheme: const DateTimePickerTheme(
                        cancel: SizedBox(),
                        confirm: SizedBox(),
                        titleHeight: 0,
                      ),
                      onChange: (value, _) {
                        rightDate = value;
                      },
                      dateFormat: 'dd.MM.yyyy',
                    ),
                  ),
                const SizedBox(height: 30),
                CustomButton(
                  color: AppColors.pureColors.blue.b900,
                  text: 'Выбрать',
                  onPressed: () {
                    widget.onConfirmed(
                      leftDate: leftDate,
                      rightDate: rightDate,
                    );
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
