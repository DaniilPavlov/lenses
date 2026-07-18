import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:lenses/common/utils/helpers/utils.dart';
import 'package:lenses/core/lenses/models/generated/generated.dart';
import 'package:lenses/l10n/app_localizations.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Какая линза (или обе) попадает в ближайшее напоминание о замене.
enum _ReplacementTarget { left, right, both }

/// Локальное напоминание о замене линз в день окончания ношения.
///
/// Планирует **одно** уведомление на ближайшую дату [LensDateModel.dateEnd]
/// среди надетых линз (утром в 9:00). Текст зависит от L / R / обеих.
/// При обновлении/снятии дат пересобирается.
class LensReplacementReminderService {
  static const _notificationId = 1001;
  static const _channelId = 'lens_replacement';
  static const _androidIcon = 'ic_notification';
  static const _notifyHour = 9;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  /// Инициализирует плагин и таймзону (без запроса permissions).
  Future<void> init() async {
    tz_data.initializeTimeZones();
    await _configureLocalTimezone();

    const androidSettings = AndroidInitializationSettings(_androidIcon);
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );
  }

  /// Запрос разрешений уведомлений / exact alarms.
  Future<void> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();

    final ios = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Пересобирает одно напоминание по текущим датам ношения.
  ///
  /// Если линз нет или дата замены уже прошла — отменяет уведомление.
  Future<void> sync(LensesPairDatesModel? pairDates, {required Locale locale}) async {
    try {
      await _configureLocalTimezone();
      await _plugin.cancel(id: _notificationId);

      final l10n = await AppLocalizations.delegate.load(locale);
      await _ensureAndroidChannel(l10n);

      final target = _nextReplacement(pairDates);
      if (target == null) {
        if (kDebugMode) {
          debugPrint('LensReplacementReminderService: no upcoming reminder');
        }
        return;
      }

      final notifyAt = tz.TZDateTime(
        tz.local,
        target.date.year,
        target.date.month,
        target.date.day,
        _notifyHour,
      );

      if (!notifyAt.isAfter(tz.TZDateTime.now(tz.local))) {
        if (kDebugMode) {
          debugPrint('LensReplacementReminderService: replacement day already passed');
        }
        return;
      }

      final (title, body) = _copyFor(target.which, l10n);
      await _schedule(notifyAt, title: title, body: body, l10n: l10n);

      if (kDebugMode) {
        debugPrint(
          'LensReplacementReminderService: scheduled ${target.which.name} at ${notifyAt.toIso8601String()}',
        );
      }
    } on Object catch (error, stackTrace) {
      debugPrint('LensReplacementReminderService.sync failed: $error\n$stackTrace');
    }
  }

  /// Ближайшая дата замены и какие линзы в этот день заканчиваются.
  ({DateTime date, _ReplacementTarget which})? _nextReplacement(LensesPairDatesModel? pairDates) {
    if (pairDates == null || pairDates.isEmpty) {
      return null;
    }

    final leftEnd = pairDates.left?.dateEnd;
    final rightEnd = pairDates.right?.dateEnd;

    if (leftEnd != null && rightEnd != null) {
      if (leftEnd.isSameDate(rightEnd)) {
        return (date: leftEnd, which: _ReplacementTarget.both);
      }
      if (leftEnd.isBefore(rightEnd)) {
        return (date: leftEnd, which: _ReplacementTarget.left);
      }
      return (date: rightEnd, which: _ReplacementTarget.right);
    }

    if (leftEnd != null) {
      return (date: leftEnd, which: _ReplacementTarget.left);
    }
    return (date: rightEnd!, which: _ReplacementTarget.right);
  }

  (String, String) _copyFor(_ReplacementTarget which, AppLocalizations l10n) {
    return switch (which) {
      _ReplacementTarget.both => (l10n.notificationTitleBoth, l10n.notificationBodyBoth),
      _ReplacementTarget.left => (l10n.notificationTitleLeft, l10n.notificationBodyLeft),
      _ReplacementTarget.right => (l10n.notificationTitleRight, l10n.notificationBodyRight),
    };
  }

  Future<void> _schedule(
    tz.TZDateTime notifyAt, {
    required String title,
    required String body,
    required AppLocalizations l10n,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        l10n.notificationChannelName,
        channelDescription: l10n.notificationChannelDescription,
        importance: Importance.high,
        priority: Priority.high,
        icon: _androidIcon,
        color: const Color(0xFF9CD05A),
      ),
      iOS: const DarwinNotificationDetails(),
    );

    try {
      await _plugin.zonedSchedule(
        id: _notificationId,
        title: title,
        body: body,
        scheduledDate: notifyAt,
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } on Object catch (error) {
      debugPrint('LensReplacementReminderService: exact failed, try alarmClock: $error');
      try {
        await _plugin.zonedSchedule(
          id: _notificationId,
          title: title,
          body: body,
          scheduledDate: notifyAt,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.alarmClock,
        );
      } on Object catch (alarmClockError) {
        debugPrint('LensReplacementReminderService: alarmClock failed, fallback inexact: $alarmClockError');
        await _plugin.zonedSchedule(
          id: _notificationId,
          title: title,
          body: body,
          scheduledDate: notifyAt,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }
    }
  }

  Future<void> _configureLocalTimezone() async {
    try {
      final timeZoneName = (await FlutterTimezone.getLocalTimezone()).identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } on Object catch (error) {
      debugPrint('LensReplacementReminderService: timezone fallback to UTC ($error)');
      tz.setLocalLocation(tz.UTC);
    }
  }

  Future<void> _ensureAndroidChannel(AppLocalizations l10n) async {
    final android = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      AndroidNotificationChannel(
        _channelId,
        l10n.notificationChannelName,
        description: l10n.notificationChannelDescription,
        importance: Importance.high,
      ),
    );
  }
}
