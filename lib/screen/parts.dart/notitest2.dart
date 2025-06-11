import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Medicine {
  final String name;
  final TimeOfDay timeToTake;

  Medicine({
    required this.name,
    required this.timeToTake,
  });
}

class MedsPage extends StatefulWidget {
  @override
  _MedsPageState createState() => _MedsPageState();
}

class _MedsPageState extends State<MedsPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<Medicine> medicines = [
    Medicine(name: 'Aspirin', timeToTake: TimeOfDay(hour: 17, minute: 58)),
    Medicine(name: 'Antibiotics', timeToTake: TimeOfDay(hour: 17, minute: 59)),
    Medicine(name: 'Painkiller', timeToTake: TimeOfDay(hour: 18, minute: 00)),
  ];

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    scheduleAlarms();
  }

  Future<void> scheduleAlarms() async {
    tz.initializeTimeZones();

    final String timeZoneName = 'Asia/Damascus';
    final tz.Location timeZone = tz.getLocation(timeZoneName);

    for (Medicine medicine in medicines) {
      try {
        final DateTime now = DateTime.now();
        final DateTime scheduledDateTime =
            _convertTimeOfDayToDateTime(now, medicine.timeToTake);

        final tz.TZDateTime scheduledTime = tz.TZDateTime(
          timeZone,
          scheduledDateTime.year,
          scheduledDateTime.month,
          scheduledDateTime.day,
          scheduledDateTime.hour,
          scheduledDateTime.minute,
        );

        if (scheduledTime.isAfter(now)) {
          // Check if the scheduled time is after the current time
          // Only schedule the notification if the scheduled time is in the future
          final AndroidNotificationDetails androidPlatformChannelSpecifics =
              AndroidNotificationDetails(
            'medication_channel',
            'Channel for medication notifications',
            importance: Importance.high,
            enableVibration: true,
            enableLights: true,
            largeIcon: DrawableResourceAndroidBitmap('drawable/flutter_logo'),
          );

          final NotificationDetails platformChannelSpecifics =
              NotificationDetails(android: androidPlatformChannelSpecifics);
          int id = medicines.indexOf(medicine);
          await flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            'Medication Reminder',
            'It\'s time to take your medication: ${medicine.name}',
            scheduledTime,
            platformChannelSpecifics,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            androidAllowWhileIdle: true,
            matchDateTimeComponents: DateTimeComponents.time,
            payload: 'medication_$id',
          );

          // Calculate remaining time until scheduled time
          Duration remainingTime = scheduledDateTime.difference(DateTime.now());
          print(
              'Take your ${medicine.name} in ${remainingTime.inMinutes} minutes');
        }
      } catch (e) {
        print('Error scheduling notification for ${medicine.name}: $e');
      }
    }
  }

  DateTime _convertTimeOfDayToDateTime(DateTime now, TimeOfDay timeOfDay) {
    final today = DateTime(now.year, now.month, now.day);
    return DateTime(
      today.year,
      today.month,
      today.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medications'),
      ),
      body: ListView.builder(
        itemCount: medicines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(medicines[index].name),
            subtitle: Text(_formatTimeOfDay(medicines[index].timeToTake)),
          );
        },
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateTime = DateTime(
      today.year,
      today.month,
      today.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    final formatter = DateFormat.jm();
    return formatter.format(dateTime);
  }
}
