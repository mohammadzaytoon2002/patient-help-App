import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:watch3/componant/bottombardoctor.dart';
import 'package:watch3/screen/doctor_screen/allpatient.dart';
import 'package:watch3/screen/doctor_screen/patientapprovedisaprove.dart';
import 'package:watch3/screen/doctor_screen/mypatient.dart';
import 'package:watch3/screen/notifiction.dart';
import 'package:watch3/screen/patient/doctor/alldoctor.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:badges/badges.dart' as badges;

class HomePagedoctor extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePagedoctor> {
  String? token;
  int? userId;
  Map<String, dynamic>? userInfo;
  List<dynamic> requests = [];
  List<dynamic> patients = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List<Map<String, dynamic>> notifications = [];
  final List<String> _images = [
    'assets/images/slider1.png', // ضع مسار الصورة الأولى هنا
    'assets/images/slider2.png', // ضع مسار الصورة الثانية هنا
  ];

  final List<String> _texts = [
    'You can easily find patients and communicate with them ', // ضع النص الأول هنا
    'Many features for you as a doctor in this application. ', // ضع النص الثاني هنا
  ];

  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    _startImageTimer();
    _initializeFirebaseMessaging();
    _initializeNotifications();
    _checkForInitialMessage();
    _loadNotifications();
  }

  void _startImageTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _images.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    userId = prefs.getInt('userId');

    if (token != null && token!.isNotEmpty && userId != null) {
      await fetchUserInfo();
      await fetchRequests();
      await fetchPatients();
    } else {
      // Handle the case where the user is not logged in
      print('User is not logged in or token/userId is null');
    }
  }

  Future<void> fetchUserInfo() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/users/me'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        userInfo = json.decode(response.body)['user'];
      });
    } else {
      throw Exception('Failed to load user info');
    }
  }

  Future<void> fetchRequests() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/from_doctor/requests'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        requests = json.decode(response.body)['requests'];
      });
    } else {
      throw Exception('Failed to load requests');
    }
  }

  Future<void> fetchPatients() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/from_doctor/patients'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        patients = json.decode(response.body)['patients'];
      });
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<int> fetchReportCount(int patientId) async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.107:8000/api/from_doctor/healthreport/count_reports/$patientId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['healthreport_count'];
    } else {
      throw Exception('Failed to load report count');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
          backgroundColor: Color.fromARGB(255, 30, 71, 114),
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Welcome ,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                userInfo != null
                    ? ' Dr. ${userInfo!['first_name']}'
                    : 'Loading...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
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
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 25),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    height: 140.0,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(0, 38, 96, 1)),
                    child: Stack(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      children: [
                        Positioned(
                          left: -(50 / 140) * width,
                          top: -(50 / 90) * width,
                          child: Container(
                            height: (50 / 100) * width * 2,
                            width: (50 / 100) * width * 2,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular((50 / 100) * width),
                                color: Color.fromRGBO(241, 237, 234, 1.0)),
                          ),
                        ),
                        Positioned(
                          left: 20, // موقع النص من اليسار
                          top: 20, // موقع النص من الأعلى
                          child: Container(
                            width: width * 0.45, // تحديد عرض الحاوية للنص
                            child: Text(
                              _texts[_currentIndex], // النص المتغير
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromRGBO(0, 38, 96, 1)),
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        // Align(
                        //         alignment: Alignment(0.4, 0), // إزاحة الصورة قليلاً نحو اليمين
                        //         child: Image.asset(
                        //           _images[_currentIndex], // صورة متغيرة
                        //           width: 180.0, // عرض الصورة
                        //           height: 100.0, // ارتفاع الصورة
                        //           fit: BoxFit.cover, // لتغطية كامل الحاوية
                        //         ),
                        //       ),
                        Align(
                          alignment: Alignment(
                              0.6, 0), // إزاحة الصورة قليلاً نحو اليمين
                          child: Image.asset(
                            _images[_currentIndex],
                            width: 130.0, // عرض
                            height: 130.0, // ارتفاع الصورة // صورة متغيرة
                            fit: BoxFit.contain, // عرض الصورة كما هي
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(height: 20),
            Text(
              'The requests sent to you:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: requests.map((request) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientDetailsPage2(
                            patientId: request['user_id'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 200,
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'http://192.168.1.107:8000${request['user']['picture']}'),
                              radius: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              '${request['user']['first_name']} ${request['user']['last_name']}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Type: ${request['diabets_type']}',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'My Patients :',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomBardoc(
                          initialIndex: 1,
                        ),
                      ),
                    );
                  },
                  child: Text('See All'),
                ),
              ],
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: AnimationLimiter(
                child: Row(
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 700),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: widget,
                      ),
                    ),
                    children: patients.map((patient) {
                      return FutureBuilder<int>(
                        future: fetchReportCount(patient['user_id']),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error');
                          } else {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PatientDetailsPage(
                                      patientId: patient['user_id'],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 200,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color.fromARGB(255, 30, 71, 114),
                                      Colors.blueGrey[200]!
                                    ],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 45,
                                      backgroundImage: NetworkImage(
                                        'http://192.168.1.107:8000${patient['user']['picture']}',
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '${patient['user']['first_name']} ${patient['user']['last_name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Type: ${patient['diabets_type'] ?? 'N/A'}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Reports: ${snapshot.data}',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
