import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/date_picker_constants.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/date_picker_theme.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/date_time_formatter.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/i18n/date_picker_i18n.dart';
import 'package:lenses/packages/flutter_cupertino_date_picker/src/widget/date_picker_title_widget.dart';

/// TimePicker widget.
///
/// @author dylan wu
/// @since 2019-05-10
class TimePickerWidget extends StatefulWidget {
  TimePickerWidget({
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
    final minTime = minDateTime ?? DateTime.parse(datePickerMinDateTime);
    final maxTime = maxDateTime ?? DateTime.parse(datePicketMaxDateTime);
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
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => TimePickerWidgetState(
        minDateTime,
        maxDateTime,
        initDateTime,
        minuteDivider,
      );
}

class TimePickerWidgetState extends State<TimePickerWidget> {
  TimePickerWidgetState(
    DateTime? minTime,
    DateTime? maxTime,
    DateTime? initTime,
    int minuteDivider,
  ) {
    minTime ??= DateTime.parse(datePickerMinDateTime);
    maxTime ??= DateTime.parse(datePicketMaxDateTime);
    initTime ??= DateTime.now();
    _minTime = minTime;
    _maxTime = maxTime;
    _currHour = initTime.hour;
    _currMinute = initTime.minute;
    _currSecond = initTime.second;

    _minuteDivider = minuteDivider;

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
    _hourScrollCtrl = FixedExtentScrollController(initialItem: _currHour - _hourRange.first);
    _minuteScrollCtrl = FixedExtentScrollController(
      initialItem: (_currMinute - _minuteRange.first) ~/ _minuteDivider,
    );
    _secondScrollCtrl = FixedExtentScrollController(
      initialItem: _currSecond - _secondRange.first,
    );

    _scrollCtrlMap = {
      'H': _hourScrollCtrl,
      'm': _minuteScrollCtrl,
      's': _secondScrollCtrl,
    };
    _valueRangeMap = {'H': _hourRange, 'm': _minuteRange, 's': _secondRange};
  }
  DateTime _minTime = DateTime(1);
  DateTime _maxTime = DateTime(1);
  int _currHour = 0;
  int _currMinute = 0;
  int _currSecond = 0;
  int _minuteDivider = 0;
  List<int> _hourRange = [];
  List<int> _minuteRange = [];
  List<int> _secondRange = [];
  FixedExtentScrollController _hourScrollCtrl = FixedExtentScrollController();
  FixedExtentScrollController _minuteScrollCtrl = FixedExtentScrollController();
  FixedExtentScrollController _secondScrollCtrl = FixedExtentScrollController();

  Map<String, FixedExtentScrollController> _scrollCtrlMap = {};
  Map<String, List<int>> _valueRangeMap = {};

  bool _isChangeTimeRange = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Material(
        color: Colors.transparent,
        child: _renderPickerView(context),
      ),
    );
  }

  /// render time picker widgets
  Widget _renderPickerView(BuildContext context) {
    final pickerWidget = _renderDatePickerWidget();

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
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _currHour,
        _currMinute,
        _currSecond,
      );
      widget.onConfirm!(dateTime, _calcSelectIndexList());
    }
    Navigator.pop(context);
  }

  /// notify selected time changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      final now = DateTime.now();
      final dateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _currHour,
        _currMinute,
        _currSecond,
      );
      widget.onChange!(dateTime, _calcSelectIndexList());
    }
  }

  /// find scroll controller by specified format
  FixedExtentScrollController _findScrollCtrl(String format) {
    var scrollCtrl = FixedExtentScrollController();
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
          if (format.contains('H')) {
            _changeHourSelection(value);
          } else if (format.contains('m')) {
            _changeMinuteSelection(value);
          } else if (format.contains('s')) {
            _changeSecondSelection(value);
          }
        },
        minuteDivider: widget.minuteDivider,
      );
      pickers.add(pickerColumn);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: pickers,
    );
  }

  Widget _renderDatePickerColumnComponent(
    FixedExtentScrollController scrollCtrl,
    List<int> valueRange,
    String format,
    ValueChanged<int> valueChanged, {
    required int minuteDivider,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: widget.pickerTheme.pickerHeight,
        decoration: BoxDecoration(color: widget.pickerTheme.backgroundColor),
        child: CupertinoPicker.builder(
          backgroundColor: widget.pickerTheme.backgroundColor,
          scrollController: scrollCtrl,
          itemExtent: widget.pickerTheme.itemHeight,
          onSelectedItemChanged: valueChanged,
          childCount: format.contains('m')
              ? _calculateMinuteChildCount(valueRange, minuteDivider)
              : valueRange.last - valueRange.first + 1,
          itemBuilder: (context, index) {
            var value = valueRange.first + index;

            if (format.contains('m')) {
              value = minuteDivider * index + valueRange.first;
            }

            return _renderDatePickerItemComponent(value, format);
          },
        ),
      ),
    );
  }

  int _calculateMinuteChildCount(List<int> valueRange, int divider) {
    if (divider == 0) {
      debugPrint('Cant devide by 0');
      return (valueRange.last - valueRange.first + 1);
    }

    return (valueRange.last - valueRange.first + 1) ~/ divider;
  }

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

  /// change the selection of hour picker
  void _changeHourSelection(int index) {
    final value = _hourRange.first + index;
    if (_currHour != value) {
      _currHour = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of minute picker
  void _changeMinuteSelection(int index) {
    final value = index * _minuteDivider + _minuteRange.first;
    if (_currMinute != value) {
      _currMinute = value;
      _changeTimeRange();
      _onSelectedChange();
    }
  }

  /// change the selection of second picker
  void _changeSecondSelection(int index) {
    final value = _secondRange.first + index;
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

    final minuteRange = _calcMinuteRange();
    final minuteRangeChanged = _minuteRange.first != minuteRange.first || _minuteRange.last != minuteRange.last;
    if (minuteRangeChanged) {
      // selected hour changed
      _currMinute = max(min(_currMinute, minuteRange.last), minuteRange.first);
    }

    final secondRange = _calcSecondRange();
    final secondRangeChanged = _secondRange.first != secondRange.first || _secondRange.last != secondRange.last;
    if (secondRangeChanged) {
      // second range changed, need limit the value of selected second
      _currSecond = max(min(_currSecond, secondRange.last), secondRange.first);
    }

    setState(() {
      _minuteRange = minuteRange;
      _secondRange = secondRange;

      _valueRangeMap['m'] = minuteRange;
      _valueRangeMap['s'] = secondRange;
    });

    if (minuteRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      final currMinute = _currMinute;
      _minuteScrollCtrl.jumpToItem((minuteRange.last - minuteRange.first) ~/ _minuteDivider);
      if (currMinute < minuteRange.last) {
        _minuteScrollCtrl.jumpToItem(currMinute - minuteRange.first);
      }
    }

    if (secondRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      final currSecond = _currSecond;
      _secondScrollCtrl.jumpToItem(secondRange.last - secondRange.first);
      if (currSecond < secondRange.last) {
        _secondScrollCtrl.jumpToItem(currSecond - secondRange.first);
      }
    }

    _isChangeTimeRange = false;
  }

  /// calculate selected index list
  List<int> _calcSelectIndexList() {
    final hourIndex = _currHour - _hourRange.first;
    final minuteIndex = _currMinute - _minuteRange.first;
    final secondIndex = _currSecond - _secondRange.first;
    return [hourIndex, minuteIndex, secondIndex];
  }

  /// calculate the range of hour
  List<int> _calcHourRange() {
    return [_minTime.hour, _maxTime.hour];
  }

  /// calculate the range of minute
  List<int> _calcMinuteRange({int? currHour}) {
    int minMinute = 0;
    int maxMinute = 59;
    final minHour = _minTime.hour;
    final maxHour = _maxTime.hour;
    currHour ??= _currHour;

    if (minHour == currHour) {
      // selected minimum hour, limit minute range
      minMinute = _minTime.minute;
    }
    if (maxHour == currHour) {
      // selected maximum hour, limit minute range
      maxMinute = _maxTime.minute;
    }
    return [minMinute, maxMinute];
  }

  /// calculate the range of second
  List<int> _calcSecondRange({int? currHour, int? currMinute}) {
    int minSecond = 0;
    int maxSecond = 59;
    final minHour = _minTime.hour;
    final maxHour = _maxTime.hour;
    final minMinute = _minTime.minute;
    final maxMinute = _maxTime.minute;

    currHour ??= _currHour;
    currMinute ??= _currMinute;

    if (minHour == currHour && minMinute == currMinute) {
      // selected minimum hour and minute, limit second range
      minSecond = _minTime.second;
    }
    if (maxHour == currHour && maxMinute == currMinute) {
      // selected maximum hour and minute, limit second range
      maxSecond = _maxTime.second;
    }
    return [minSecond, maxSecond];
  }
}
