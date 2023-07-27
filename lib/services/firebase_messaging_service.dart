import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:nossa_lista_de_compras/custom_notification.dart';
import 'package:nossa_lista_de_compras/routes.dart';
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
    _onMessage();
    _onMessageOpenedApp();
  }

  getDeviceFirebaseToken() async {
    final token = await FirebaseMessaging.instance.getToken();
    print('===============================');
    print(token);
    print('===============================');
  }

  _onMessage(){
    FirebaseMessaging.onMessage.listen((message){
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      if(notification != null && android != null){
        _notificationService.showNotification(
          CustomNotification(
              id: android.hashCode,
              title: notification!.title,
              body: notification.body,
              payload: message.data['route'] ?? ''
          )
        );
      }
    });
  }

  _onMessageOpenedApp(){
    FirebaseMessaging.onMessageOpenedApp.listen((_goToPayloadAfterMessage));
  }

  _goToPayloadAfterMessage(message) {
    final String route = message.data['route'] ?? '';
    if(route.isNotEmpty){
      Routes.navigatorKey?.currentState?.pushNamed(route);
    }
  }
}