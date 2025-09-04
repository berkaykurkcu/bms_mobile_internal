import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService(this._plugin);

  final FlutterLocalNotificationsPlugin _plugin;

  static const AndroidNotificationChannel _defaultChannel =
      AndroidNotificationChannel(
        'bms_default',
        'Genel Bildirimler',
        description: 'Uygulamanın genel bildirim kanalı',
        importance: Importance.high,
      );

  Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();

    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        log('Notification tapped: ${response.payload}');
      },
    );

    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await android?.requestNotificationsPermission();
    await android?.createNotificationChannel(_defaultChannel);

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  Future<void> showTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      _NotificationDetails.channelId,
      _NotificationDetails.channelName,
      channelDescription: _NotificationDetails.channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      1001,
      'Test',
      'Bildirim testi başarılı',
      details,
    );
  }
}

class _NotificationDetails {
  static const String channelId = 'bms_default';
  static const String channelName = 'Genel Bildirimler';
  static const String channelDescription = 'Uygulamanın genel bildirim kanalı';
}
