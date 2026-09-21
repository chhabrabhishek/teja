import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// One notification a day. That is the entire notification strategy.
///
/// Scheduled locally rather than pushed: the reminder is the same every day and
/// needs no server knowledge, so APNs infrastructure would buy nothing and cost
/// a token lifecycle, a delivery pipeline and a privacy disclosure.
class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const _dailyId = 1;
  static const _testId = 99;
  static const _channelId = 'teja_daily_prompt';

  bool _ready = false;

  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    await _plugin.initialize(
      const InitializationSettings(
        iOS: DarwinInitializationSettings(
          // Asked for explicitly after the first publish, not on cold launch.
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
    );
    _ready = true;
  }

  /// Returns true if the user granted permission.
  Future<bool> requestPermission() async {
    await init();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    }
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.requestNotificationsPermission() ?? false;
  }

  Future<bool> hasPermission() async {
    await init();
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      final settings = await ios.checkPermissions();
      return settings?.isAlertEnabled ?? false;
    }
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.areNotificationsEnabled() ?? false;
  }

  /// Re-scheduling replaces the existing notification, so this is idempotent.
  Future<void> scheduleDaily({required int hour, String? timezoneName}) async {
    await init();
    await cancel();

    final location = _resolveLocation(timezoneName);
    final now = tz.TZDateTime.now(location);
    var first = tz.TZDateTime(location, now.year, now.month, now.day, hour);
    if (!first.isAfter(now)) first = first.add(const Duration(days: 1));

    await _plugin.zonedSchedule(
      _dailyId,
      "Today's prompt is ready",
      'Five minutes is enough.',
      first,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          _channelId,
          'Daily prompt',
          channelDescription: 'A single daily reminder to create.',
          importance: Importance.defaultImportance,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      // Only consulted on iOS < 10; ignored by every device we support.
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      // Repeats at the same wall-clock time every day.
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancel() async {
    await init();
    await _plugin.cancel(_dailyId);
  }

  /// Debug-only: fires shortly so the whole path can be verified without
  /// waiting for the real hour. Uses a separate id so it can't disturb the
  /// scheduled daily reminder.
  Future<tz.TZDateTime> scheduleTest({
    Duration delay = const Duration(seconds: 10),
    String? timezoneName,
  }) async {
    assert(kDebugMode, 'scheduleTest must never run in a release build');
    await init();
    final location = _resolveLocation(timezoneName);
    final when = tz.TZDateTime.now(location).add(delay);

    await _plugin.zonedSchedule(
      _testId,
      "Today's prompt is ready",
      'Five minutes is enough.',
      when,
      const NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          _channelId,
          'Daily prompt',
          channelDescription: 'A single daily reminder to create.',
          importance: Importance.defaultImportance,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    return when;
  }

  Future<List<PendingNotificationRequest>> pending() async {
    await init();
    return _plugin.pendingNotificationRequests();
  }

  Future<bool> isScheduled() async {
    await init();
    final pending = await _plugin.pendingNotificationRequests();
    return pending.any((r) => r.id == _dailyId);
  }

  tz.Location _resolveLocation(String? name) {
    if (name != null && name.isNotEmpty) {
      try {
        return tz.getLocation(name);
      } catch (_) {
        if (kDebugMode) debugPrint('Unknown timezone "$name", falling back to UTC');
      }
    }
    return tz.UTC;
  }
}

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(FlutterLocalNotificationsPlugin()),
);
