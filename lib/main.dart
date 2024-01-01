import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Local Notifications Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _initializeTimer() {
    const duration = Duration(seconds: 10); // تحديث البيانات كل 30 ثانية
    _timer = Timer.periodic(duration, (_) {
      _checkAndSendNotification();
    });
  }

  Future<void> _checkAndSendNotification() async {
    try {
      var response =
          await http.get(Uri.parse('https://bb.egyticsports.com/public/api/order'));
      if (response.statusCode == 200) {
        var jsonData = response.body;
        if (jsonData.isNotEmpty) {
          await _showNotification();
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _showNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Notification Title',
      'Notification Body - Data Available',
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Local Notifications Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Perform actions if needed when the button is pressed
          },
          child: Text('Button'),
        ),
      ),
    );
  }
}
