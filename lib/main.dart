import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'notification.dart';

void main() {
  runApp(MyApp());
}

// Future init() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*  return const MaterialApp(
      home: HomePage(),
    );*/

    return FutureBuilder(
      // Initialize FlutterFire
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return HomePage();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return HomePage();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator(
          color: Colors.blue,
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();

    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    super.initState();
  }

  _changeData(String msg) => setState(() => notificationData = msg);

  _changeBody(String msg) => setState(() => notificationBody = msg);

  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: new MediaQueryData(),
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  notificationTitle,
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  notificationBody,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  notificationData,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}
