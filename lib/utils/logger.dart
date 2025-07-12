import 'package:logger/logger.dart';

/// Стандартный логгер, который следует использовать по всему проекту
final logger = Logger(
  printer: PrettyPrinter(
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);