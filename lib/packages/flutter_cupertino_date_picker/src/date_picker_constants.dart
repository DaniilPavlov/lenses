typedef DateValueCallback = Function(
  DateTime dateTime,
  List<int> selectedIndex,
);

/// Pressed cancel callback.
typedef DateVoidCallback = Function();

/// Default value of minimum datetime.
const String datePickerMinDateTime = '1900-01-01 00:00:00';

/// Default value of maximum datetime.
const String datePicketMaxDateTime = '2100-12-31 23:59:59';

/// Default value of date format
const String datePickerDateFormat = 'yyyy-MM-dd';

/// Default value of time format
const String dateTimePicketTimeFormat = 'HH:mm:ss';

/// Default value of datetime format
const String dateTimePickerDateTimeFormat = 'yyyyMMdd HH:mm:ss';
