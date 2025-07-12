// ignore_for_file: always_use_package_imports, no_logic_in_create_state, prefer_typing_uninitialized_variables, type_annotate_public_apis, avoid_dynamic_calls,avoid-returning-widgets,member-ordering-extended, always_put_required_named_parameters_first, avoid_multiple_declarations_per_line, cascade_invocations, omit_local_variable_types

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../date_picker_constants.dart';
import '../date_picker_theme.dart';
import '../date_time_formatter.dart';
import '../i18n/date_picker_i18n.dart';
import 'date_picker_title_widget.dart';

/// Solar months of 31 days.
const List<int> _solarMonthsOf31Days = <int>[1, 3, 5, 7, 8, 10, 12];

/// DatePicker widget.
///
/// @author dylan wu
/// @since 2019-05-10
class DatePickerWidget extends StatefulWidget {
  DatePickerWidget({
    super.key,
    required this.onMonthChangeStartWithFirstDate,
    this.minDateTime,
    this.maxDateTime,
    this.initialDateTime,
    this.dateFormat = DATETIME_PICKER_DATE_FORMAT,
    this.locale = DATETIME_PICKER_LOCALE_DEFAULT,
    this.pickerTheme = DateTimePickerTheme.Default,
    this.onCancel,
    this.onChange,
    this.onConfirm,
    this.popWidget = true,
  }) {
    final minTime = minDateTime ?? DateTime.parse(DATE_PICKER_MIN_DATETIME);
    final maxTime = maxDateTime ?? DateTime.parse(DATE_PICKER_MAX_DATETIME);
    assert(minTime.compareTo(maxTime) < 0);
  }

  final DateTime? minDateTime, maxDateTime, initialDateTime;
  final String? dateFormat;
  final DateTimePickerLocale locale;
  final DateTimePickerTheme pickerTheme;
  final bool popWidget;
  final DateVoidCallback? onCancel;
  final DateValueCallback? onChange, onConfirm;
  // ignore: member-ordering-extended
  final bool onMonthChangeStartWithFirstDate;

  @override
  State<StatefulWidget> createState() => _DatePickerWidgetState(
        minDateTime,
        maxDateTime,
        initialDateTime,
      );
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _minDateTime = DateTime(0), _maxDateTime = DateTime(0);
  int _currYear = 0, _currMonth = 0, _currDay = 0;
  List<int> _yearRange = [], _monthRange = [], _dayRange = [];
  FixedExtentScrollController _yearScrollCtrl = FixedExtentScrollController(),
      _monthScrollCtrl = FixedExtentScrollController(),
      _dayScrollCtrl = FixedExtentScrollController();

  Map<String, FixedExtentScrollController> _scrollCtrlMap = {};
  Map<String, List<int>> _valueRangeMap = {};

  bool _isChangeDateRange = false;

  _DatePickerWidgetState(
    DateTime? minDateTime,
    DateTime? maxDateTime,
    DateTime? initialDateTime,
  ) {
    // handle current selected year、month、day
    final initDateTime = initialDateTime ?? DateTime.now();
    _currYear = initDateTime.year;
    _currMonth = initDateTime.month;
    _currDay = initDateTime.day;

    // handle DateTime range
    _minDateTime = minDateTime ?? DateTime.parse(DATE_PICKER_MIN_DATETIME);
    _maxDateTime = maxDateTime ?? DateTime.parse(DATE_PICKER_MAX_DATETIME);

    // limit the range of year
    _yearRange = _calcYearRange();
    _currYear = min(max(_minDateTime.year, _currYear), _maxDateTime.year);

    // limit the range of month
    _monthRange = _calcMonthRange();
    _currMonth = min(max(_monthRange.first, _currMonth), _monthRange.last);

    // limit the range of day
    _dayRange = _calcDayRange();
    _currDay = min(max(_dayRange.first, _currDay), _dayRange.last);

    // create scroll controller
    _yearScrollCtrl = FixedExtentScrollController(initialItem: _currYear - _yearRange.first);
    _monthScrollCtrl = FixedExtentScrollController(
      initialItem: _currMonth - _monthRange.first,
    );
    _dayScrollCtrl = FixedExtentScrollController(initialItem: _currDay - _dayRange.first);

    _scrollCtrlMap = {
      'y': _yearScrollCtrl,
      'M': _monthScrollCtrl,
      'd': _dayScrollCtrl,
    };
    _valueRangeMap = {'y': _yearRange, 'M': _monthRange, 'd': _dayRange};
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        color: Colors.transparent,
        child: _renderPickerView(context),
      ),
    );
  }

  /// render date picker widgets
  Widget _renderPickerView(BuildContext context) {
    final datePickerWidget = _renderDatePickerWidget();

    // display the title widget
    if (widget.pickerTheme.title != null || widget.pickerTheme.showTitle) {
      final Widget titleWidget = DatePickerTitleWidget(
        _onPressedCancel,
        _onPressedConfirm,
        pickerTheme: widget.pickerTheme,
        locale: widget.locale,
      );
      return Column(children: <Widget>[titleWidget, datePickerWidget]);
    }
    return datePickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    if (widget.popWidget) {
      Navigator.pop(context);
    }
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      final dateTime = DateTime(_currYear, _currMonth, _currDay);
      widget.onConfirm!(dateTime, _calcSelectIndexList());
    }
    if (widget.popWidget) {
      Navigator.pop(context);
    }
  }

  /// notify selected date changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      final dateTime = DateTime(_currYear, _currMonth, _currDay);
      widget.onChange!(dateTime, _calcSelectIndexList());
    }
  }

  /// find scroll controller by specified format
  FixedExtentScrollController? _findScrollCtrl(String format) {
    FixedExtentScrollController? scrollCtrl;
    _scrollCtrlMap.forEach((key, value) {
      if (format.contains(key)) {
        scrollCtrl = value;
      }
    });
    return scrollCtrl;
  }

  /// find item value range by specified format
  List<int> _findPickerItemRange(String format) {
    var valueRange = <int>[];
    _valueRangeMap.forEach((key, value) {
      if (format.contains(key)) {
        valueRange = value;
      }
    });
    return valueRange;
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    final pickers = <Widget>[];
    final formatArr = DateTimeFormatter.splitDateFormat(widget.dateFormat);
    for (final format in formatArr) {
      final valueRange = _findPickerItemRange(format);

      final pickerColumn = _renderDatePickerColumnComponent(
        _findScrollCtrl(format),
        valueRange,
        format,
        (value) {
          if (format.contains('y')) {
            _changeYearSelection(value);
          } else if (format.contains('M')) {
            _changeMonthSelection(value);
          } else if (format.contains('d')) {
            _changeDaySelection(value);
          }
        },
      );
      pickers.add(pickerColumn);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: pickers,
    );
  }

  Widget _renderDatePickerColumnComponent(
    FixedExtentScrollController? scrollCtrl,
    List<int>? valueRange,
    String format,
    ValueChanged<int>? valueChanged,
  ) {
    return Expanded(
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          height: widget.pickerTheme.pickerHeight,
          decoration: BoxDecoration(color: widget.pickerTheme.backgroundColor),
          child: CupertinoPicker.builder(
            backgroundColor: widget.pickerTheme.backgroundColor,
            scrollController: scrollCtrl,
            itemExtent: widget.pickerTheme.itemHeight,
            onSelectedItemChanged: valueChanged,
            childCount:
                valueRange?.last == null || valueRange?.first == null ? null : valueRange!.last - valueRange.first + 1,
            itemBuilder: (context, index) => valueRange?.first == null
                ? null
                : _renderDatePickerItemComponent(
                    valueRange!.first + index,
                    format,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _renderDatePickerItemComponent(int value, String format) {
    return Container(
      height: widget.pickerTheme.itemHeight,
      alignment: Alignment.center,
      child: Text(
        DateTimeFormatter.formatDateTime(value, format, widget.locale),
        style: widget.pickerTheme.itemTextStyle ?? DATETIME_PICKER_ITEM_TEXT_STYLE,
      ),
    );
  }

  /// change the selection of year picker
  void _changeYearSelection(int index) {
    final year = _yearRange.first + index;
    if (_currYear != year) {
      _currYear = year;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of month picker
  void _changeMonthSelection(int index) {
    final month = _monthRange.first + index;
    if (_currMonth != month) {
      _currMonth = month;
      _changeDateRange();
      _onSelectedChange();
    }
  }

  /// change the selection of day picker
  void _changeDaySelection(int index) {
    final dayOfMonth = _dayRange.first + index;
    if (_currDay != dayOfMonth) {
      _currDay = dayOfMonth;
      _onSelectedChange();
    }
  }

  /// change range of month and day
  void _changeDateRange() {
    if (_isChangeDateRange) {
      return;
    }
    _isChangeDateRange = true;

    final monthRange = _calcMonthRange();
    final monthRangeChanged = _monthRange.first != monthRange.first || _monthRange.last != monthRange.last;
    if (monthRangeChanged) {
      // selected year changed
      _currMonth = max(min(_currMonth, monthRange.last), monthRange.first);
    }

    final dayRange = _calcDayRange();
    final dayRangeChanged = _dayRange.first != dayRange.first || _dayRange.last != dayRange.last;
    if (dayRangeChanged) {
      // day range changed, need limit the value of selected day
      if (!widget.onMonthChangeStartWithFirstDate) {
        max(min(_currDay, dayRange.last), dayRange.first);
      } else {
        _currDay = dayRange.first;
      }
    }

    setState(() {
      _monthRange = monthRange;
      _dayRange = dayRange;

      _valueRangeMap['M'] = monthRange;
      _valueRangeMap['d'] = dayRange;
    });

    if (monthRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      final currMonth = _currMonth;
      _monthScrollCtrl.jumpToItem(monthRange.last - monthRange.first);
      if (currMonth < monthRange.last) {
        _monthScrollCtrl.jumpToItem(currMonth - monthRange.first);
      }
    }

    if (dayRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      final currDay = _currDay;
      _dayScrollCtrl.jumpToItem(dayRange.last - dayRange.first);
      if (currDay < dayRange.last) {
        _dayScrollCtrl.jumpToItem(currDay - dayRange.first);
      }
    }

    _isChangeDateRange = false;
  }

  /// calculate the count of day in current month
  int _calcDayCountOfMonth() {
    if (_currMonth == 2) {
      return isLeapYear(_currYear) ? 29 : 28;
    } else if (_solarMonthsOf31Days.contains(_currMonth)) {
      return 31;
    }
    return 30;
  }

  /// whether or not is leap year
  bool isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || year % 400 == 0;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    final yearIndex = _currYear - _minDateTime.year;
    final monthIndex = _currMonth - _monthRange.first;
    final dayIndex = _currDay - _dayRange.first;
    return [yearIndex, monthIndex, dayIndex];
  }

  /// calculate the range of year
  List<int> _calcYearRange() {
    return [_minDateTime.year, _maxDateTime.year];
  }

  /// calculate the range of month
  List<int> _calcMonthRange() {
    int minMonth = 1, maxMonth = 12;
    final minYear = _minDateTime.year;
    final maxYear = _maxDateTime.year;
    if (minYear == _currYear) {
      // selected minimum year, limit month range
      minMonth = _minDateTime.month;
    }
    if (maxYear == _currYear) {
      // selected maximum year, limit month range
      maxMonth = _maxDateTime.month;
    }
    return [minMonth, maxMonth];
  }

  /// calculate the range of day
  List<int> _calcDayRange({int? currMonth}) {
    int minDay = 1, maxDay = _calcDayCountOfMonth();
    final minYear = _minDateTime.year;
    final maxYear = _maxDateTime.year;
    final minMonth = _minDateTime.month;
    final maxMonth = _maxDateTime.month;
    currMonth ??= _currMonth;
    if (minYear == _currYear && minMonth == currMonth) {
      // selected minimum year and month, limit day range
      minDay = _minDateTime.day;
    }
    if (maxYear == _currYear && maxMonth == currMonth) {
      // selected maximum year and month, limit day range
      maxDay = _maxDateTime.day;
    }
    return [minDay, maxDay];
  }
}
