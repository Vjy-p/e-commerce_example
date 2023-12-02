import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:firebase_testing/screens/notifications/notification_screen.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling a background message ${message.messageId}');
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey(debugLabel: "Main Navigator");

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'id',
  'title',
  importance: Importance.high,
);
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationServices {
  init() async {
    await Firebase.initializeApp();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  initialise() {
    var initialzationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );

    var initializationSettings = InitializationSettings(
        android: initialzationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint("\n onclick response: ${details.payload} ");
        navigatorKey.currentState!.push(MaterialPageRoute(
            builder: (context) => const NotificationsScreen()));
      },
    );

    notificationsDetails() {
      return NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          // channel.description,
          icon: "@mipmap/ic_launcher",
        ),
        iOS: const DarwinNotificationDetails(),
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint(
          "\nresponse ${message.data} title : ${message.notification!.title} body : ${message.notification!.body}");

      RemoteNotification? notification = message.notification;

      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        notificationsDetails(),
        // payload: message.data['payload'],
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("\nnotifiy response: ${message.data}");
      navigatorKey.currentState!.push(
          MaterialPageRoute(builder: (context) => const NotificationsScreen()));
    });
  }
}
