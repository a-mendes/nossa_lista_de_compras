import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:nossa_lista_de_compras/routes.dart';

import '../custom_notification.dart';

class NotificationService {
  late FlutterLocalNotificationsPlugin localNotificationsPlugin;
  late AndroidNotificationDetails androidDetails;

  NotificationService() {
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    _setupNotifications();
  }

  _setupNotifications() async {
    await _initializeNotifications();
  }

  _initializeNotifications() async {
    //Icone
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android,
      ),
      onSelectNotification: _onSelectNotification,
    );
  }

  _onSelectNotification(String? payload){
    if(payload == null || payload.isEmpty){
      return;
    }

    Navigator.of(Routes.navigatorKey!.currentContext!).pushReplacementNamed(payload);
  }

  showNotification(CustomNotification notification){
    androidDetails = const AndroidNotificationDetails(
      'notifications_app',
      'notifications',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
    );

    localNotificationsPlugin.show(
        notification.id,
        notification.title,
        notification.body,
        NotificationDetails(
            android: androidDetails
        ),
        payload: notification.payload
    );
  }

  checkForNotifications() async {
    final details = await localNotificationsPlugin.getNotificationAppLaunchDetails();
    if(details != null && details.didNotificationLaunchApp){
      _onSelectNotification(details.payload);
    }
  }
}