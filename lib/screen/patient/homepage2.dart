import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:watch3/componant/card_items_copyhome.dart';
import 'package:watch3/screen/models/health.dart';
import 'package:watch3/screen/notifiction.dart';
import 'package:watch3/screen/parts.dart/navigatorbar.dart';
import 'package:watch3/screen/patient/medicine/SHOWMEDI.dart';
import 'package:watch3/screen/profile/profile.dart';
import 'package:watch3/screen/patient/doctor/doctorhome.dart';
import 'package:watch3/screen/patient/medicine/medcinecard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medication App',
      home: HomePage2(),
    );
  }
}

class HomePage2 extends StatefulWidget {
  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  List medications = [];
  String? token;
  Map<String, dynamic> userInfo = {};
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<Map<String, dynamic>> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _initializeNotifications();
    _initializeFirebaseMessaging();
    _loadNotifications();
    _checkForInitialMessage();
  }

  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print('Notifications initialized.');
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message: ${message.notification!.title}");
      print("Received message body: ${message.notification!.body}");
      _showLocalNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Message opened: ${message.notification!.title}");
      _addNotification(message);
    });
  }

  void _checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _addNotification(initialMessage);
    }
  }

  void _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    int? userId = prefs.getInt('userId');

    if (token != null && token!.isNotEmpty && userId != null) {
      print('Token and userId loaded from SharedPreferences.');
      await fetchUserInfo();
      await fetchMedications();
      await _scheduleMedicationsNotifications();
    } else {
      print('User is not logged in or token/userId is null');
    }
  }

  Future<void> fetchUserInfo() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/users/me'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        userInfo = json.decode(response.body)['user'];
        print('User info fetched successfully.');
      });
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<void> fetchMedications() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/medication'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        medications = json.decode(response.body)['medications'];
        print('Medications fetched successfully.');
      });
    } else {
      throw Exception('Failed to load medications');
    }
  }

  Future<void> _scheduleMedicationsNotifications() async {
    for (var medication in medications) {
      final medicationName = medication['name'];
      final medicationTimeString = medication['time'];
      final medicationFreq = medication['freq'];

      final DateTime medicationTime =
          DateFormat.jm().parse(medicationTimeString);
      final DateTime now = DateTime.now();

      DateTime scheduledTime = DateTime(
        now.year,
        now.month,
        now.day,
        medicationTime.hour,
        medicationTime.minute,
      );

      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(Duration(days: 1));
      }

      await _scheduleMedicationNotification(medicationName, scheduledTime);

      if (medicationFreq == 'every_month') {
        for (int i = 1; i <= 12; i++) {
          await _scheduleMedicationNotification(
              medicationName, scheduledTime.add(Duration(days: 30 * i)));
        }
      }
    }
    print('Medication notifications scheduled.');
  }

  Future<void> _scheduleMedicationNotification(
      String medicationName, DateTime scheduledTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
      0,
      'Medication Reminder',
      'It\'s time to take your medication: $medicationName',
      scheduledTime,
      platformChannelSpecifics,
    );

    print('Scheduling notification for $medicationName at $scheduledTime');
  }

  void _loadNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedNotifications = prefs.getString('notifications');
    if (savedNotifications != null) {
      setState(() {
        notifications =
            List<Map<String, dynamic>>.from(json.decode(savedNotifications));
        // Ensure all notifications have a timestamp
        for (var notification in notifications) {
          if (notification['timestamp'] == null) {
            notification['timestamp'] = DateTime.now().millisecondsSinceEpoch;
          }
        }
        // Sort notifications by timestamp, with the newest first
        notifications.sort(
            (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
      });
    }
  }

  void _saveNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notifications', json.encode(notifications));
  }

  void _showLocalNotification(RemoteMessage message) {
    flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'your_channel_name',
          channelDescription: 'your_channel_description',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    _addNotification(message);
  }

  void _addNotification(RemoteMessage message) {
    setState(() {
      notifications.add({
        'title': message.notification!.title ?? '',
        'body': message.notification!.body ?? '',
        'seen': false,
        'timestamp': DateTime.now().millisecondsSinceEpoch, // Add timestamp
      });

      // Sort notifications by timestamp, with the newest first
      notifications.sort(
          (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
    });

    _saveNotifications();

    _showPopupNotification(context, message.notification!.title ?? '',
        message.notification!.body ?? '');
  }

  void _showPopupNotification(BuildContext context, String title, String body) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          backgroundColor: Colors.blue,
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              Text(
                ' Damascus',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NotificationsPage(notifications: notifications),
                    ),
                  ).then((_) => setState(() {}));
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 5),
                      badges.Badge(
                        showBadge: notifications
                            .any((notification) => !notification['seen']),
                        badgeContent: Text(
                          '${notifications.where((notification) => !notification['seen']).length}',
                          style: TextStyle(
                              color: Color.fromARGB(255, 214, 190, 190)),
                        ),
                        position:
                            badges.BadgePosition.topEnd(top: -12, end: -12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        child: Container(
          color: Color.fromARGB(255, 236, 247, 247),
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SizedBox(height: 20),
              CardItemsHome(
                text: 'Age: 23',
                text2: 'Sex: ${userInfo['gender'] ?? 'Unknown'}',
                image: userInfo['picture'] != null
                    ? Image.network(
                        'http://192.168.1.107:8000${userInfo['picture']}',
                        height: 100,
                        width: 100,
                      )
                    : Image.asset(
                        'assets/images/logo.png',
                        height: 100,
                        width: 100,
                      ),
                title:
                    '${userInfo['first_name'] ?? ''} ${userInfo['last_name'] ?? ''}',
                color: Constants.lightBlue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomBar(
                              initialIndex: 4,
                            )),
                  );
                },
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Schedule',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${medications.length}',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 15),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ShowMedication()),
                      );
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                height: 180,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: medications.length,
                  itemBuilder: (context, index) {
                    final medication = medications[index];
                    return MedicationCard(medication: medication);
                  },
                ),
              ),

              SizedBox(height: 20),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  'My doctors',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                DoctorsHome(),
                SizedBox(height: 20),
                Text(
                  'Health Information:',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              SizedBox(height: 10),
              HealthInformationSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              '${userInfo['first_name'] ?? ''} ${userInfo['last_name'] ?? ''}',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              userInfo['email'] ?? '',
              style: TextStyle(fontSize: 16.0),
            ),
            currentAccountPicture: GestureDetector(
              onTap: () {
                _showEnlargedImage(context);
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                  userInfo['picture'] != null
                      ? 'http://192.168.1.107:8000${userInfo['picture']}'
                      : 'assets/images/logo.png',
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/drawer_bg.jpg'),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfile1()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.medication),
            title: Text('Medications'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowMedication()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.local_hospital),
            title: Text('Doctors'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DoctorsHome()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log out'),
            onTap: () {
              _logOut(context);
            },
          ),
        ],
      ),
    );
  }

  void _showEnlargedImage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(
                  userInfo['picture'] != null
                      ? 'http://192.168.1.107:8000${userInfo['picture']}'
                      : 'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text(
                  '${userInfo['first_name'] ?? ''} ${userInfo['last_name'] ?? ''}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(userInfo['email'] ?? ''),
              ],
            ),
          ),
        );
      },
    );
  }

  void _logOut(BuildContext context) {
    // Log out implementation
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon, color: Colors.blue),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

class Constants {
  static const Color lightBlue = Color.fromARGB(255, 85, 162, 244);
}
