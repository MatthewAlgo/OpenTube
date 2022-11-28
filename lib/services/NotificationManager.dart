import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await _localNotificationService.initialize(
      initializationSettings, 
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    return const NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> showNotification(int id, String title, String body) async {
    final notificationDetails = await _notificationDetails();
    await _localNotificationService.show(id, title, body, notificationDetails);
  }

  void onDidReceiveNotification(
      int id, String? title, String? body, String? payload) {
    print('Notification Received');
  }

  void selectNotification(String? payload) async {
    print('Notification Clicked');
  }
}

