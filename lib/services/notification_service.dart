import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _notifications.initialize(settings);
  }

  static Future<void> scheduleRepeatingNotification(int intervalMinutes) async {
    await _notifications.cancelAll();

    await _notifications.periodicallyShow(
      0,
      '💧 Su içme vakti!',
      'Sağlıklı kalmak için su içmeyi unutma!',
      _getRepeatInterval(intervalMinutes),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'aquabit_channel',
          'AquaBit Hatırlatıcı',
          channelDescription: 'Su içme hatırlatıcısı',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static RepeatInterval _getRepeatInterval(int minutes) {
    if (minutes <= 30) return RepeatInterval.hourly;
    return RepeatInterval.hourly;
  }

  static Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}
