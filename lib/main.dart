import 'package:flutter/material.dart';
import 'package:libnotif/admin.dart';
import 'package:libnotif/home.dart';
import 'package:libnotif/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const LOGIN = "LOGIN_KEY";
const REGISTERNO = "REGISTER_NO";
const ADMIN = "ADMIN";

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: 'AIzaSyDzOAkXITMeo1Wn2V-DqPNU8DCmgHlBsKk',
          appId: '1:957077238857:android:6b6d3118f33f08fd32fb98',
          messagingSenderId: '957077238857',
          projectId: 'libn-7d7ca',
          storageBucket: 'libn-7d7ca.appspot.com'));

  tz.initializeTimeZones();
  initializeNotifications();

  runApp(MyApp());
}

void initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleNotification(DateTime dueDate, int notificationId) async {
  final tz.TZDateTime scheduledDate = tz.TZDateTime.from(dueDate, tz.local);

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'due_date_channel', // Channel ID
    'Due Date Reminders', // Channel Name
    //'No', // Channel Description
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    notificationId,
    'Reminder',
    'Your due date is today!',
    scheduledDate,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Scaffold(
        backgroundColor: Color(0xff99baff),
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'Assets/library-icon.webp',
                            height: 100,
                          ),
                          Text(
                            "LibNotif.",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 100.0,
                left: 0,
                right: 0,
                child: Center(
                  child: SizedBox(
                    width: 300,
                    height: 40,
                    child: Builder(
                      builder: (context) => ElevatedButton(
                        onPressed: () {
                          checkLogin(context);
                          scheduleDueDateNotifications();
                        },
                        child: Text(
                          "Get Started",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void checkLogin(BuildContext context) async {
    final sharedPref = await SharedPreferences.getInstance();
    final _userLogin = sharedPref.getBool(LOGIN);
    final _registerNo = sharedPref.getString(REGISTERNO);
    final _admin = sharedPref.getBool(ADMIN);

    if (_admin != null && _admin == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPage()),
      );
    } else if (_userLogin == null || _userLogin == false) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(loggedInEmail: _registerNo!),
        ),
      );
    }
  }

  void scheduleDueDateNotifications() {
    List<DateTime> dueDates = [
      DateTime(2024, 6, 15, 8, 0, 0),
      // Add more due dates here
    ];

    for (int i = 0; i < dueDates.length; i++) {
      scheduleNotification(dueDates[i], i);
    }
  }
}