import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Default value of DatePicker's background color.
const dateTimePickerBackgroundColor = Colors.white;

/// Default value of whether show title widget or not.
const dateTimePickerShowTitleDefault = true;

/// Default value of DatePicker's height.
const double dateTimePickerHeight = 210.0;

/// Default value of DatePicker's title height.
const double dateTimePickerTitleHeight = 44.0;

/// Default value of DatePicker's column height.
const double dateTimePickerItemHeight = 36.0;

/// Default value of DatePicker's item [TextStyle].
const TextStyle dateTimePickerItemTextStyle = TextStyle(color: Color(0xFF000046), fontSize: 16.0);

class DateTimePickerTheme with Diagnosticable {
  /// DateTimePicker theme.
  ///
  /// [backgroundColor] DatePicker's background color.
  /// [cancelTextStyle] Default cancel widget's [TextStyle].
  /// [confirmTextStyle] Default confirm widget's [TextStyle].
  /// [cancel] Custom cancel widget.
  /// [confirm] Custom confirm widget.
  /// [title] Custom title widget. If specify a title widget, the cancel and confirm widgets will not display. Must set [titleHeight] value for custom title widget.
  /// [showTitle] Whether display title widget or not. If set false, the default cancel and confirm widgets will not display, but the custom title widget will display if had specified one custom title widget.
  /// [pickerHeight] The value of DatePicker's height.
  /// [titleHeight] The value of DatePicker's title height.
  /// [itemHeight] The value of DatePicker's column height.
  /// [itemTextStyle] The value of DatePicker's column [TextStyle].
  const DateTimePickerTheme({
    this.backgroundColor = dateTimePickerBackgroundColor,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.cancel,
    this.confirm,
    this.title,
    this.showTitle = dateTimePickerShowTitleDefault,
    this.pickerHeight = dateTimePickerHeight,
    this.titleHeight = dateTimePickerTitleHeight,
    this.itemHeight = dateTimePickerItemHeight,
    this.itemTextStyle = dateTimePickerItemTextStyle,
  });
  final cancelDefault = const Text('OK');

  static const DateTimePickerTheme defaultDateTimePicker = DateTimePickerTheme();

  /// DatePicker's background color.
  final Color backgroundColor;

  /// Default cancel widget's [TextStyle].
  final TextStyle? cancelTextStyle;

  /// Default confirm widget's [TextStyle].
  final TextStyle? confirmTextStyle;

  /// Custom cancel [Widget].
  final Widget? cancel;

  /// Custom confirm [Widget].
  final Widget? confirm;

  /// Custom title [Widget]. If specify a title widget, the cancel and confirm widgets will not display.
  final Widget? title;

  /// Whether display title widget or not. If set false, the default cancel and confirm widgets will not display, but the custom title widget will display if had specified one custom title widget.
  final bool showTitle;

  /// The value of DatePicker's height.
  final double pickerHeight;

  /// The value of DatePicker's title height.
  final double titleHeight;

  /// The value of DatePicker's column height.
  final double itemHeight;

  /// The value of DatePicker's column [TextStyle].
  final TextStyle? itemTextStyle;
}
