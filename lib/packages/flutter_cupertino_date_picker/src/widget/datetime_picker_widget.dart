import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/date_picker.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/date_picker_constants.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/date_picker_theme.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/date_time_formatter.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/i18n/date_picker_i18n.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/widget/date_picker_title_widget.dart';

/// DateTimePicker widget. Can display date and time picker.
///
/// @author dylan wu
/// @since 2019-05-10
class DateTimePickerWidget extends StatefulWidget {
  DateTimePickerWidget({
    super.key,
    this.minDateTime,
    this.maxDateTime,
    this.initDateTime,
    this.dateFormat = dateTimePicketTimeFormat,
    this.locale = dateTimePicketLocaleDefault,
    this.pickerTheme = DateTimePickerTheme.defaultDateTimePicker,
    this.minuteDivider = 1,
    this.onCancel,
    this.onChange,
    this.onConfirm,
  }) {
    final DateTime minTime = minDateTime ?? DateTime.parse(datePickerMinDateTime);
    final DateTime maxTime = maxDateTime ?? DateTime.parse(datePicketMaxDateTime);
    assert(minTime.compareTo(maxTime) < 0);
  }

  final DateTime? minDateTime;
  final DateTime? maxDateTime;
  final DateTime? initDateTime;
  final String? dateFormat;
  final DateTimePickerLocale locale;
  final DateTimePickerTheme pickerTheme;
  final DateVoidCallback? onCancel;
  final DateValueCallback? onChange;
  final DateValueCallback? onConfirm;
  final int minuteDivider;

  @override
  State<StatefulWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  @override
  void initState() {
    super.initState();
    DateTime? minTime = widget.minDateTime;
    DateTime? maxTime = widget.maxDateTime;
    DateTime? initTime = widget.initDateTime;
    // check minTime value
    minTime ??= DateTime.parse(datePickerMinDateTime);
    // check maxTime value
    maxTime ??= DateTime.parse(datePicketMaxDateTime);
    // check initTime value
    initTime ??= DateTime.now();
    // limit initTime value
    if (initTime.compareTo(minTime) < 0) {
      initTime = minTime;
    }
    if (initTime.compareTo(maxTime) > 0) {
      initTime = maxTime;
    }

    _minTime = minTime;
    _maxTime = maxTime;
    _currHour = initTime.hour;
    _currMinute = initTime.minute;
    _currSecond = initTime.second;

    _minuteDivider = widget.minuteDivider;

    // limit the range of date
    _dayRange = _calcDayRange();
    final int currDate = initTime.difference(_baselineDate).inDays;
    _currDay = min(max(_dayRange.first, currDate), _dayRange.last);

    // limit the range of hour
    _hourRange = _calcHourRange();
    _currHour = min(max(_hourRange.first, _currHour), _hourRange.last);

    // limit the range of minute
    _minuteRange = _calcMinuteRange();
    _currMinute = min(max(_minuteRange.first, _currMinute), _minuteRange.last);

    // limit the range of second
    _secondRange = _calcSecondRange();
    _currSecond = min(max(_secondRange.first, _currSecond), _secondRange.last);

    // create scroll controller
    _dayScrollCtrl = FixedExtentScrollController(initialItem: _currDay - _dayRange.first);
    _hourScrollCtrl = FixedExtentScrollController(initialItem: _currHour - _hourRange.first);
    _minuteScrollCtrl = FixedExtentScrollController(initialItem: (_currMinute - _minuteRange.first) ~/ _minuteDivider);
    _secondScrollCtrl = FixedExtentScrollController(initialItem: _currSecond - _secondRange.first);

    _scrollCtrlMap = {'H': _hourScrollCtrl, 'm': _minuteScrollCtrl, 's': _secondScrollCtrl};
    _valueRangeMap = {'H': _hourRange, 'm': _minuteRange, 's': _secondRange};
  }

  DateTime _minTime = DateTime(0);
  DateTime _maxTime = DateTime(0);
  int _currDay = 0;
  int _currHour = 0;
  int _currMinute = 0;
  int _currSecond = 0;
  int _minuteDivider = 0;
  List<int> _dayRange = [];
  List<int> _hourRange = [];
  List<int> _minuteRange = [];
  List<int> _secondRange = [];
  FixedExtentScrollController _dayScrollCtrl = FixedExtentScrollController();
  FixedExtentScrollController _hourScrollCtrl = FixedExtentScrollController();
  FixedExtentScrollController _minuteScrollCtrl = FixedExtentScrollController();
  FixedExtentScrollController _secondScrollCtrl = FixedExtentScrollController();

  Map<String, FixedExtentScrollController> _scrollCtrlMap = {};
  Map<String, List<int>> _valueRangeMap = {};

  bool _isChangeTimeRange = false;

  final DateTime _baselineDate = DateTime(1900);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(color: Colors.transparent, child: _renderPickerView(context)),
    );
  }

  /// render time picker widgets
  Widget _renderPickerView(BuildContext context) {
    final Widget pickerWidget = _renderDatePickerWidget();

    // display the title widget
    if (widget.pickerTheme.title != null || widget.pickerTheme.showTitle) {
      final Widget titleWidget = DatePickerTitleWidget(
        _onPressedCancel,
        _onPressedConfirm,
        pickerTheme: widget.pickerTheme,
        locale: widget.locale,
      );
      return Column(children: <Widget>[titleWidget, pickerWidget]);
    }
    return pickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    widget.onCancel?.call();
    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      final DateTime day = _baselineDate.add(Duration(days: _currDay));
      final DateTime dateTime = DateTime(day.year, day.month, day.day, _currHour, _currMinute, _currSecond);
      widget.onConfirm!(dateTime, _calcSelectIndexList());
    }
    Navigator.pop(context);
  }

  /// notify selected datetime changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      final DateTime day = _baselineDate.add(Duration(days: _currDay));
      final DateTime dateTime = DateTime(day.year, day.month, day.day, _currHour, _currMinute, _currSecond);
      widget.onChange!(dateTime, _calcSelectIndexList());
    }
  }

  /// find scroll controller by specified format
  FixedExtentScrollController _findScrollCtrl(String format) {
    FixedExtentScrollController scrollCtrl = FixedExtentScrollController();
    _scrollCtrlMap.forEach((key, value) {
      if (format.contains(key)) {
        scrollCtrl = value;
      }
    });
    return scrollCtrl;
  }

  /// find item value range by specified format
  List<int> _findPickerItemRange(String format) {
    List<int> valueRange = [];
    _valueRangeMap.forEach((key, value) {
      if (format.contains(key)) {
        valueRange = value;
      }
    });
    return valueRange;
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    final List<Widget> pickers = [];
    final List<String> formatArr = DateTimeFormatter.splitDateFormat(
      widget.dateFormat,
      mode: DateTimePickerMode.datetime,
    );
    final int count = formatArr.length;
    final int dayFlex = count > 3 ? count - 1 : count;

    // render day picker column
    final String dayFormat = formatArr.removeAt(0);
    final Widget dayPickerColumn = _renderDatePickerColumnComponent(
      _dayScrollCtrl,
      _dayRange,
      dayFormat,
      _changeDaySelection,
      flex: dayFlex,
      itemBuilder: (context, index) => _renderDayPickerItemComponent(_dayRange.first + index, dayFormat),
    );
    pickers.add(dayPickerColumn);

    // render time picker column
    for (final format in formatArr) {
      final List<int> valueRange = _findPickerItemRange(format);

      final Widget pickerColumn = _renderDatePickerColumnComponent(
        _findScrollCtrl(format),
        valueRange,
        format,
        (value) {
          if (format.contains('H')) {
            _changeHourSelection(value);
          } else if (format.contains('m')) {
            _changeMinuteSelection(value);
          } else if (format.contains('s')) {
            _changeSecondSelection(value);
          }
        },
        flex: 1,
        minuteDivider: widget.minuteDivider,
      );
      pickers.add(pickerColumn);
    }
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  Widget _renderDatePickerColumnComponent(
    FixedExtentScrollController scrollCtrl,
    List<int> valueRange,
    String format,
    ValueChanged<int> valueChanged, {
    required int flex,
    int? minuteDivider,
    IndexedWidgetBuilder? itemBuilder,
  }) {
    final IndexedWidgetBuilder builder =
        itemBuilder ??
        (context, index) {
          int value = valueRange.first + index;

          if (format.contains('m')) {
            value = minuteDivider! * index;
          }

          return _renderDatePickerItemComponent(value, format);
        };

    final Widget columnWidget = Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      height: widget.pickerTheme.pickerHeight,
      decoration: BoxDecoration(color: widget.pickerTheme.backgroundColor),
      child: CupertinoPicker.builder(
        backgroundColor: widget.pickerTheme.backgroundColor,
        scrollController: scrollCtrl,
        itemExtent: widget.pickerTheme.itemHeight,
        onSelectedItemChanged: valueChanged,
        childCount: format.contains('m')
            ? _calculateMinuteChildCount(valueRange, minuteDivider!)
            : valueRange.last - valueRange.first + 1,
        itemBuilder: builder,
      ),
    );
    return Expanded(flex: flex, child: columnWidget);
  }

  int _calculateMinuteChildCount(List<int> valueRange, int divider) {
    if (divider == 0) {
      debugPrint('Cant devide by 0');
      return valueRange.last - valueRange.first + 1;
    }

    return (valueRange.last - valueRange.first + 1) ~/ divider;
  }

  /// render day picker item
  Widget _renderDayPickerItemComponent(int value, String? format) {
    final DateTime dateTime = _baselineDate.add(Duration(days: value));
    return Container(
      height: widget.pickerTheme.itemHeight,
      alignment: Alignment.center,
      child: Text(
        DateTimeFormatter.formatDate(dateTime, format, widget.locale),
        style: widget.pickerTheme.itemTextStyle ?? dateTimePickerItemTextStyle,
      ),
    );
  }

  /// render hour、minute、second picker item
  Widget _renderDatePickerItemComponent(int value, String format) {
    return Container(
      height: widget.pickerTheme.itemHeight,
      alignment: Alignment.center,
      child: Text(
        DateTimeFormatter.formatDateTime(value, format, widget.locale),
        style: widget.pickerTheme.itemTextStyle ?? dateTimePickerItemTextStyle,
      ),
    );
  }

  /// change the selection of day picker
  void _changeDaySelection(int days) {
    final int value = _dayRange.first + days;
    if (_currDay != value) {
      _currDay = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of hour picker
  void _changeHourSelection(int index) {
    final int value = _hourRange.first + index;
    if (_currHour != value) {
      _currHour = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of minute picker
  void _changeMinuteSelection(int index) {
    final int value = index * _minuteDivider;
    //    int value = _minuteRange.first + index;
    if (_currMinute != value) {
      _currMinute = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of second picker
  void _changeSecondSelection(int index) {
    final int value = _secondRange.first + index;
    if (_currSecond != value) {
      _currSecond = value;
      _onSelectedChange();
    }
  }

  /// change range of minute and second
  void _changeTimeRange() {
    if (_isChangeTimeRange) {
      return;
    }
    _isChangeTimeRange = true;

    final List<int> hourRange = _calcHourRange();
    final bool hourRangeChanged = _hourRange.first != hourRange.first || _hourRange.last != hourRange.last;
    if (hourRangeChanged) {
      // selected day changed
      _currHour = max(min(_currHour, hourRange.last), hourRange.first);
    }

    final List<int> minuteRange = _calcMinuteRange();
    final bool minuteRangeChanged = _minuteRange.first != minuteRange.first || _minuteRange.last != minuteRange.last;
    if (minuteRangeChanged) {
      // selected hour changed
      _currMinute = max(min(_currMinute, minuteRange.last), minuteRange.first);
    }

    final List<int> secondRange = _calcSecondRange();
    final bool secondRangeChanged = _secondRange.first != secondRange.first || _secondRange.last != secondRange.last;
    if (secondRangeChanged) {
      // second range changed, need limit the value of selected second
      _currSecond = max(min(_currSecond, secondRange.last), secondRange.first);
    }

    setState(() {
      _hourRange = hourRange;
      _minuteRange = minuteRange;
      _secondRange = secondRange;

      _valueRangeMap['H'] = hourRange;
      _valueRangeMap['m'] = minuteRange;
      _valueRangeMap['s'] = secondRange;
    });

    if (hourRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      final int currHour = _currHour;
      _hourScrollCtrl.jumpToItem(hourRange.last - hourRange.first);
      if (currHour < hourRange.last) {
        _hourScrollCtrl.jumpToItem(currHour - hourRange.first);
      }
    }

    if (minuteRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      final int currMinute = _currMinute;
      _minuteScrollCtrl.jumpToItem((minuteRange.last - minuteRange.first) ~/ _minuteDivider);
      if (currMinute < minuteRange.last) {
        _minuteScrollCtrl.jumpToItem(currMinute - minuteRange.first);
      }
    }

    if (secondRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      final int currSecond = _currSecond;
      _secondScrollCtrl.jumpToItem(secondRange.last - secondRange.first);
      if (currSecond < secondRange.last) {
        _secondScrollCtrl.jumpToItem(currSecond - secondRange.first);
      }
    }

    _isChangeTimeRange = false;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    final int hourIndex = _currHour - _hourRange.first;
    final int minuteIndex = _currMinute - _minuteRange.first;
    final int secondIndex = _currSecond - _secondRange.first;
    return [hourIndex, minuteIndex, secondIndex];
  }

  /// calculate the range of day
  List<int> _calcDayRange() {
    final int minDays = _minTime.difference(_baselineDate).inDays;
    final int maxDays = _maxTime.difference(_baselineDate).inDays;
    return [minDays, maxDays];
  }

  /// calculate the range of hour
  List<int> _calcHourRange() {
    int minHour = 0;
    int maxHour = 23;
    if (_currDay == _dayRange.first) {
      minHour = _minTime.hour;
    }
    if (_currDay == _dayRange.last) {
      maxHour = _maxTime.hour;
    }
    return [minHour, maxHour];
  }

  /// calculate the range of minute
  List<int> _calcMinuteRange({int? currHour}) {
    int minMinute = 0;
    int maxMinute = 59;
    currHour ??= _currHour;

    if (_currDay == _dayRange.first && currHour == _minTime.hour) {
      // selected minimum day、hour, limit minute range
      minMinute = _minTime.minute;
    }
    if (_currDay == _dayRange.last && currHour == _maxTime.hour) {
      // selected maximum day、hour, limit minute range
      maxMinute = _maxTime.minute;
    }
    return [minMinute, maxMinute];
  }

  /// calculate the range of second
  List<int> _calcSecondRange({int? currHour, int? currMinute}) {
    int minSecond = 0;
    int maxSecond = 59;

    currHour ??= _currHour;
    currMinute ??= _currMinute;

    if (_currDay == _dayRange.first && currHour == _minTime.hour && currMinute == _minTime.minute) {
      // selected minimum hour and minute, limit second range
      minSecond = _minTime.second;
    }
    if (_currDay == _dayRange.last && currHour == _maxTime.hour && currMinute == _maxTime.minute) {
      // selected maximum hour and minute, limit second range
      maxSecond = _maxTime.second;
    }
    return [minSecond, maxSecond];
  }
}
