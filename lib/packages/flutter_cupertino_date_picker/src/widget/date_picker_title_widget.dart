import 'package:flutter/material.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/date_picker_constants.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/date_picker_theme.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/i18n/date_picker_i18n.dart';

/// DatePicker's title widget.
///
/// @author dylan wu
/// @since 2019-05-16
class DatePickerTitleWidget extends StatelessWidget {
  const DatePickerTitleWidget(
    this.onCancel,
    this.onConfirm, {
    super.key,
    required this.pickerTheme,
    required this.locale,
  });

  final DateTimePickerTheme pickerTheme;
  final DateTimePickerLocale locale;
  final DateVoidCallback onCancel;
  final DateVoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    if (pickerTheme.title != null) {
      return pickerTheme.title!;
    }
    return Container(
      height: pickerTheme.titleHeight,
      decoration: BoxDecoration(color: pickerTheme.backgroundColor),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _renderCancelWidget(context),
          _renderConfirmWidget(context),
        ],
      ),
    );
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context) {
    if (isCustomTitleWidget()) {
      // has custom title button widget
      if (pickerTheme.cancel == null) {
        return const Offstage();
      }
    }

    var cancelWidget = pickerTheme.cancel;
    if (cancelWidget == null) {
      final textStyle = pickerTheme.cancelTextStyle ??
          TextStyle(
            color: Theme.of(context).unselectedWidgetColor,
            fontSize: 16.0,
          );
      cancelWidget = Text(
        DatePickerI18n.getLocaleCancel(locale),
        style: textStyle,
      );
    }

    return SizedBox(
      height: pickerTheme.titleHeight,
      child: TextButton(
        onPressed: onCancel,
        child: cancelWidget,
      ),
    );
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    if (isCustomTitleWidget()) {
      // has custom title button widget
      if (pickerTheme.confirm == null) {
        return const Offstage();
      }
    }

    var confirmWidget = pickerTheme.confirm;
    if (confirmWidget == null) {
      final textStyle = pickerTheme.confirmTextStyle ??
          TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 16.0,
          );
      confirmWidget = Text(
        DatePickerI18n.getLocaleDone(locale) ?? '',
        style: textStyle,
      );
    }

    return SizedBox(
      height: pickerTheme.titleHeight,
      child: TextButton(
        onPressed: onConfirm,
        child: confirmWidget,
      ),
    );
  }

  bool isCustomTitleWidget() {
    return pickerTheme.cancel != null || pickerTheme.confirm != null || pickerTheme.title != null;
  }
}
