import 'package:flutter/material.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/flutter_cupertino_date_picker_fork.dart';
import 'package:lenses/styles/const_colors_styles.dart';
import 'package:lenses/styles/const_text_styles.dart';
import 'package:lenses/widgets/buttons/custom_button.dart';

class PutOnDateSheet extends StatefulWidget {
  final void Function({DateTime? rightDate, DateTime? leftDate}) onConfirmed;
  final DateTime? leftPut;
  final DateTime? rightPut;
  const PutOnDateSheet({
    required this.onConfirmed,
    required this.leftPut,
    required this.rightPut,
    super.key,
  });

  @override
  State<PutOnDateSheet> createState() => _PutOnDateSheetState();
}

class _PutOnDateSheetState extends State<PutOnDateSheet> {
  bool leftActive = true;

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
                  Padding(
                    padding: const EdgeInsets.only(top: 40, bottom: 30),
                    child: Text(
                      widget.leftPut != null && widget.rightPut != null
                          ? 'Когда надеты линзы'
                          : widget.rightPut != null
                              ? 'Правая линза надета'
                              : 'Левая линза надета',
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
              Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
                clipBehavior: Clip.hardEdge,
                child: DatePickerWidget(
                  onMonthChangeStartWithFirstDate: false,
                  initialDateTime: widget.leftPut ?? widget.rightPut,
                  minDateTime: DateTime.now().subtract(const Duration(days: 15)),
                  maxDateTime: DateTime.now().add(const Duration(days: 5)),
                  locale: DateTimePickerLocale.ru,
                  dateFormat: 'dd.MM.yyyy',
                  pickerTheme: const DateTimePickerTheme(
                    cancel: SizedBox(),
                    confirm: SizedBox(),
                    titleHeight: 0,
                  ),
                  onChange: (dateTime, _) => setState(() {
                    date = dateTime;
                  }),
                  onConfirm: (date, i) {
                    widget.onConfirmed(
                      leftDate: widget.leftPut != null ? date : null,
                      rightDate: widget.rightPut != null ? date : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                color: AppColors.pureColors.blue.b900,
                text: 'Выбрать',
                onPressed: () {
                  widget.onConfirmed(
                    leftDate: widget.leftPut != null ? date : null,
                    rightDate: widget.rightPut != null ? date : null,
                  );
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
