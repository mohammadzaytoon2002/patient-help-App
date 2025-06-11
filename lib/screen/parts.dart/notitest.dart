import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Medication {
  final String name;
  final TimeOfDay time;

  Medication({
    required this.name,
    required this.time,
  });
}

class NotificationPage1 extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage1> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<Medication> medications = [
    Medication(name: 'Aspirin', time: TimeOfDay(hour: 18, minute: 52)),
    Medication(name: 'Antibiotics', time: TimeOfDay(hour: 18, minute: 53)),
    Medication(name: 'Painkiller', time: TimeOfDay(hour: 18, minute: 54)),
  ];

  @override
  void initState() {
    super.initState();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print('Init state called');
  }

  Future<void> scheduleNotifications() async {
    print('Scheduling notifications...');
    for (var med in medications) {
      await scheduleNotificationForMedication(med);
    }
  }

  Future<void> scheduleNotificationForMedication(Medication med) async {
    print('Scheduling notification for ${med.name}');
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'medication_channel',
      'medication_channel',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      enableVibration: true,
      enableLights: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Convert medication time to DateTime
    var now = DateTime.now();
    var scheduledDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      med.time.hour,
      med.time.minute,
    );

    // Check if scheduled time is in the past, if yes, schedule for next day
    if (scheduledDateTime.isBefore(now)) {
      scheduledDateTime = scheduledDateTime.add(Duration(days: 1));
    }

    tz.TZDateTime scheduledDate =
        tz.TZDateTime.from(scheduledDateTime, tz.local);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      medications.indexOf(med), // Use index as notification id
      'Time to take ${med.name}',
      'Remember to take your ${med.name} now!',
      scheduledDate,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload:
          'notification payload${med.name}', // Add payload for notification
    );
    print('Notification scheduled for ${med.name}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medication Reminders'),
      ),
      body: ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          var med = medications[index];
          return ListTile(
            title: Text(med.name),
            subtitle: Text('Time: ${med.time.hour}:${med.time.minute}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('تنبيه'),
                content: Text('سيتم إرسال الإشعار بعد 2 ثانية.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // إغلاق الرسالة
                      // إرسال الإشعارات بعد تأخير 2 ثانية
                      Future.delayed(Duration(seconds: 2), () {
                        scheduleNotifications();
                      });
                    },
                    child: Text('موافق'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.notifications),
      ),
    );
  }
}
