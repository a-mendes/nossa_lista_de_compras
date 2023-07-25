import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nossa_lista_de_compras/services/notification_service.dart';

class FirebaseMessagingService {
  final NotificationService _notificationService;

  FirebaseMessagingService(this._notificationService);

  Future<void> initialize() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      badge: true,
      sound: true,
      alert: true,
    );

    getDeviceFirebaseToken();
    //_onMessage();
  }

  getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    //print
  }
}