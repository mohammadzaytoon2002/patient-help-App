import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/screen/patient/homepage2.dart';

// class NotificationsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notifications'),
//       ),
//       body: NotificationsManager.notifications.isEmpty
//           ? Center(
//               child: Text('No notifications'),
//             )
//           : ListView.builder(
//               itemCount: NotificationsManager.notifications.length,
//               itemBuilder: (context, index) {
//                 final notification = NotificationsManager.notifications[index];
//                 return ListTile(
//                   title: Text(notification['title']),
//                   subtitle: Text(notification['body']),
//                 );
//               },
//             ),
//     );
//   }
// }

// class NotificationsManager {
//   static List<Map<String, dynamic>> notifications = [];

//   static void addNotification(Map<String, dynamic> notification) {
//     notifications.add(notification);
//   }

//   static void clearNotifications() {
//     notifications.clear();
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:intl/intl.dart';

// class NotificationDetailsPage extends StatelessWidget {
//   final List notifications;

//   NotificationDetailsPage({required this.notifications});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Notification Details'),
//       ),
//       body: ListView.builder(
//         itemCount: notifications.length,
//         itemBuilder: (context, index) {
//           final notification = notifications[index];
//           return ListTile(
//             title: Text(notification['name']),
//             subtitle: Text(notification['time']),
//           );
//         },
//       ),
//     );
//   }
// }
class NotificationsPage extends StatefulWidget {
  final List<Map<String, dynamic>> notifications;

  NotificationsPage({required this.notifications});

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<Map<String, dynamic>> get notifications => widget.notifications;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          final notificationDate =
              DateTime.fromMillisecondsSinceEpoch(notification['timestamp']);
          final formattedDate =
              DateFormat.yMMMd().add_jm().format(notificationDate);

          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
                _saveNotifications();
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Notification dismissed')),
              );
            },
            background: Container(color: Colors.red),
            child: ListTile(
              title: Text(
                notification['title'] ?? '',
                style: TextStyle(
                  color: notification['seen'] ? Colors.grey : Colors.black,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification['body'] ?? ''),
                  Text(
                    formattedDate,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  notifications[index]['seen'] = true;
                  _saveNotifications();
                });
              },
            ),
          );
        },
      ),
    );
  }

  void _saveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notifications', json.encode(notifications));
  }
}
