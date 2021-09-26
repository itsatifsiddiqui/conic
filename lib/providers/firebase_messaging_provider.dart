import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

export 'package:firebase_messaging/firebase_messaging.dart';

final firebaseMessagingProvider = Provider<FirebaseMessagingProvider>((ref) {
  return FirebaseMessagingProvider(ref.read);
});

class FirebaseMessagingProvider {
  FirebaseMessagingProvider(this.read);
  final Reader read;
  final messaging = FirebaseMessaging.instance;

  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static const channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications.',
    importance: Importance.max,
  );

  static Future<void> init() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  }

  Future<void> initFCM() async {
    final settings = await messaging.requestPermission();
    _log('User granted permission: ${settings.authorizationStatus}');
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      _log('onMessageOpenedApp');
      _log('Message data: ${message.data}');
    });

    FirebaseMessaging.onMessage.listen((message) {
      _log('Got a message whilst in the foreground!');
      _log('Message data: ${message.data}');

      if (message.notification != null) {
        _log('Message also contained a notification: ${message.notification}');
      }
      final notification = message.notification;
      final android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              priority: Priority.max,
              icon: 'launch_background',
            ),
          ),
        );
      }
    });

    log('FCM Device Token: ${await getToken()}', name: 'FirebaseMessagingProvider');
  }

  Future<String?> getToken() {
    return messaging.getToken();
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log('Handling a background message ${message.messageId}', name: 'FirebaseMessagingProvider');
}

void _log(dynamic message) => log(message.toString(), name: 'FirebaseMessagingProvider');

// Once created, we can now update FCM to use our own channel rather than the default FCM one.
// To do this, open the android/app/src/main/AndroidManifest.xml file for your FlutterProject project.
// Add the following meta-data schema within the application component:

// <meta-data
//   android:name="com.google.firebase.messaging.default_notification_channel_id"
//   android:value="high_importance_channel" />
