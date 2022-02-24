import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
  // Or do other work.
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final streamCtlr = StreamController<String>.broadcast();
  final titleCtlr = StreamController<String>.broadcast();
  final bodyCtlr = StreamController<String>.broadcast();

  setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessage.listen(
      (message) async {
        if (message.data.containsKey('data')) {
          // Handle data message
          streamCtlr.sink.add(message.data['data']);

          // showNotification(message.data['data'],message.data['data']);

        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
          streamCtlr.sink.add(message.data['notification']);
          // showNotification(message.data['data'],message.data['data']);
        }
        // Or do other work.
        titleCtlr.sink.add(message.notification!.title!);
        bodyCtlr.sink.add(message.notification!.body!);
        showNotification(
            message.notification!.title!, message.notification!.body!);
      },
    );
    // With this token you can test it easily on your phone
    final token =
        _firebaseMessaging.getToken().then((value) => print('Token: $value'));
  }

  void showNotification(String title, String body) async {
    await _demoNotification(title, body);
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> _demoNotification(String title, String body) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_ID', 'channel name',
        importance: Importance.max,
        playSound: true,
        sound: /*'sound'*/ null,
        showProgress: true,
        priority: Priority.high,
        ticker: 'test ticker');

    var iOSChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSChannelSpecifics);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: 'test');
  }

  dispose() {
    streamCtlr.close();
    bodyCtlr.close();
    titleCtlr.close();
  }
}
