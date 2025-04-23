import 'package:agri_chem/main.dart';
import 'package:agri_chem/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    tz.initializeTimeZones();

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const NotificationScreen()),
        );
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'reminder_channel', // ID
      'Reminders', // Title
      description: 'Channel for scheduled reminders',
      importance: Importance.max,
    );
    await _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'foreground_channel',
      'Foreground Notifications',
      channelDescription: 'Channel for foreground FCM notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _notifications.show(0, title, body, platformDetails);
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required Duration delay,
  }) async {
    await _notifications.zonedSchedule(
      androidScheduleMode: AndroidScheduleMode.exact,
      0, // Notification ID
      title,
      body,
      tz.TZDateTime.now(tz.local).add(delay),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Channel for scheduled reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      matchDateTimeComponents: null, // set this if it's a repeating alarm
      payload: 'reminder_payload',
    );
  }
}
