import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health/health.dart';
import 'package:http/http.dart' as http;
import 'package:watch3/screen/parts.dart/watchpage1.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../componant/custom.dart';

class WatchScreen extends StatefulWidget {
  @override
  _WatchScreenState createState() => _WatchScreenState();
}

class _WatchScreenState extends State<WatchScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  HealthFactory health = HealthFactory();
  Map<HealthDataType, Map<String, dynamic>> latestHealthDataPoints = {};

  final Map<HealthDataType, Color> dataTypeColorMap = {
    HealthDataType.HEART_RATE: Colors.red,
    HealthDataType.BLOOD_OXYGEN: Colors.purple,
  };

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
    _initializeHealthData();
  }

  Future<void> _initializeHealthData() async {
    try {
      bool isAuthorized = await _requestAuthorization();
      if (isAuthorized) {
        await _fetchHealthData();
        // await _sendHealthDataToApi();
      } else {
        print("Authorization not granted");
      }
    } catch (e) {
      print("Error initializing health data: $e");
    }
  }

  Future<bool> _requestAuthorization() async {
    List<HealthDataType> types = [
      HealthDataType.HEART_RATE,
      HealthDataType.BLOOD_OXYGEN,
    ];
    return await health.requestAuthorization(types);
  }

  Future<void> _fetchHealthData() async {
    try {
      List<HealthDataType> types = [
        HealthDataType.HEART_RATE,
        HealthDataType.BLOOD_OXYGEN,
      ];
      DateTime now = DateTime.now();
      DateTime start = DateTime(2000, 1, 1); // Start from a very early date
      DateTime end = now;

      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        start,
        end,
        types,
      );

      if (healthData.isEmpty) {
        print("No health data found");
      } else {
        // Sort by date to get the latest entries
        healthData.sort((a, b) => b.dateTo.compareTo(a.dateTo));

        // Keep only the latest entry for each type
        for (var dataPoint in healthData) {
          if (dataPoint.type == HealthDataType.HEART_RATE ||
              dataPoint.type == HealthDataType.BLOOD_OXYGEN) {
            if (!latestHealthDataPoints.containsKey(dataPoint.type)) {
              String formattedDateTime =
                  "${dataPoint.dateFrom.year}-${dataPoint.dateFrom.month}-${dataPoint.dateFrom.day} ${dataPoint.dateFrom.hour}:${dataPoint.dateFrom.minute}";
              latestHealthDataPoints[dataPoint.type] = {
                'value': dataPoint.value,
                'unit': dataPoint.unit,
                'date': formattedDateTime,
                'color': dataTypeColorMap[dataPoint.type] ?? Colors.black,
              };
            }
          }
        }
        setState(() {});
      }
    } catch (e) {
      print("Error fetching health data: $e");
    }
  }

  Future<void> _sendHealthDataToApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedToken = prefs.getString('token');

    try {
      if (latestHealthDataPoints.containsKey(HealthDataType.BLOOD_OXYGEN)) {
        final bloodOxygenData =
            latestHealthDataPoints[HealthDataType.BLOOD_OXYGEN];
        final response = await http.post(
          Uri.parse('http://192.168.1.107:8000/api/healthInfo/blood_oxygen'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $storedToken',
          },
          body: '{"value": ${bloodOxygenData!['value']}}',
        );
        if (response.statusCode == 200) {
          print('Blood oxygen data sent successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Blood oxygen data sent successfully",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print('Failed to send blood oxygen data: ${response.statusCode}');
        }
      }

      if (latestHealthDataPoints.containsKey(HealthDataType.HEART_RATE)) {
        final heartRateData = latestHealthDataPoints[HealthDataType.HEART_RATE];
        final response = await http.post(
          Uri.parse('http://192.168.1.107:8000/api/healthInfo/heartbeat'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $storedToken',
          },
          body: '{"value": ${heartRateData!['value']}}',
        );
        if (response.statusCode == 200) {
          print('Heart rate data sent successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Heart rate data sent successfully",
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          print('Failed to send heart rate data: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error sending health data to API: $e');
    }
  }

  Future<void> googleLogin(BuildContext context) async {
    try {
      if (_currentUser == null) {
        // No user signed in, proceed with sign-in
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          // User canceled the sign-in
          return;
        }
        setState(() {
          _currentUser = googleUser;
        });
      } else {
        // User already signed in, offer sign out
        await _googleSignIn.signOut();
        setState(() {
          _currentUser = null;
        });
      }

      // Navigate to MyHomePageWatch after successful sign-in
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WatchScreen(),
        ),
      );
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0),
        child: AppBar(
          backgroundColor: Colors.blue,
          shape: CustomShapeBorder(),
          toolbarHeight: 150.0,
          elevation: 0,
          leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Using smart watch',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(width: 16),
              Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/logo.png'),
                  height: 73,
                  width: 80,
                  color: Colors.white.withOpacity(1)),
            ],
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/watch1.jpeg',
                height: 300,
                width: 400,
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Icon(
                  Icons.help_outline,
                  color: Colors.blue,
                  size: 30,
                ),
              ),
            ],
          ),
          Center(
            child: Text(
              'First please sign in with your Google Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => googleLogin(context),
            icon: Image.asset(
              'assets/images/google.png',
              height: 24,
              width: 24,
            ),
            label: Text('Sign in with Google'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              textStyle: TextStyle(fontSize: 16),
              side: BorderSide(color: Colors.black),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _sendHealthDataToApi,
            child: Text('Fetch Recent Health Info'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
              textStyle: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
