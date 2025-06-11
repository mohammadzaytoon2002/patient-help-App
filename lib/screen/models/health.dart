import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart'; // Ensure you import the correct package

class HealthInformationSection extends StatefulWidget {
  @override
  _HealthInformationSectionState createState() =>
      _HealthInformationSectionState();
}

class _HealthInformationSectionState extends State<HealthInformationSection> {
  int bloodSugar = 0;
  //int heartbeat = 0;
  int type_diabetes = 0;
  int HbAc1 = 0;
  int blood_oxygen = 0;
  String? token;
  String bloodSugarTime = '';
  String heartbeatTime = '';
  String typeSugarTime = '';
  String HbAc1SugarTime = '';
  String blood_oxygenTime = '';

  int heartbeat = 75;

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null && token!.isNotEmpty) {
      await fetchData();
    } else {
      print('Token is null or empty');
    }
  }

  void _playAlertSound() async {
    if (heartbeat > 120) {
      AudioCache cache = AudioCache();
      const alertSound =
          'alert_sound.mp3'; // Replace with your actual audio file path
      //   AudioPlayer player = await cache.play(alertSound);
    }
  }

// وظيفة لعرض الشاشة المنبثقة تحتوي على الرسم البياني
  void _showChartDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Heartbeat Chart',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  height: 200,
                  child:
                      _buildHeartRateChart(), // استخدم مكون الرسم البياني هنا
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchData() async {
    // Fetch blood sugar data
    var bloodSugarResponse = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/healthInfo/lastBlood_sugar'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (bloodSugarResponse.statusCode == 200) {
      setState(() {
        var data = json.decode(bloodSugarResponse.body)['health_information'];
        bloodSugar = data['value'];
        bloodSugarTime =
            DateTime.parse(data['created_at']).toLocal().toString();
      });
    }

    // Fetch heartbeat data
    var heartbeatResponse = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/healthInfo/lastheartbeat'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (heartbeatResponse.statusCode == 200) {
      setState(() {
        var data = json.decode(heartbeatResponse.body)['health_information'];
        heartbeat = data['value'];
        heartbeatTime = DateTime.parse(data['created_at']).toLocal().toString();
      });
    }

    var type_dibetesresponse = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/healthInfo/lasttype'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (type_dibetesresponse.statusCode == 200) {
      setState(() {
        var data = json.decode(type_dibetesresponse.body)['health_information'];
        type_diabetes = data['value'];
        print(type_diabetes);

        typeSugarTime = DateTime.parse(data['created_at']).toLocal().toString();
      });
    }

    var HbAc1response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/healthInfo/lasthbac1'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (HbAc1response.statusCode == 200) {
      setState(() {
        var data = json.decode(HbAc1response.body)['health_information'];
        HbAc1 = data['value'];
        HbAc1SugarTime =
            DateTime.parse(data['created_at']).toLocal().toString();
      });
    }

    var blood_oxygenresponse = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/healthInfo/lastblood_oxygen'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );
    if (blood_oxygenresponse.statusCode == 200) {
      setState(() {
        var data = json.decode(blood_oxygenresponse.body)['health_information'];
        blood_oxygen = data['value'];
        print(blood_oxygen);

        blood_oxygenTime =
            DateTime.parse(data['created_at']).toLocal().toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadToken();
    fetchData();
  }

  Future<void> _showAddRecordDialog(String url) async {
    TextEditingController valueController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Value'),
          content: TextField(
            controller: valueController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: "Enter value"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                String currentDateTime = DateTime.now().toIso8601String();
                var response =
                    await http.post(Uri.parse(url), headers: <String, String>{
                  'Authorization': 'Bearer $token',
                }, body: {
                  'value': valueController.text,
                  'timestamp': currentDateTime,
                });
                if (response.statusCode == 200) {
                  fetchData(); // Refresh data
                  Navigator.of(context).pop();
                } else {
                  // Handle error
                  print('Failed to add record');
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: const Color.fromARGB(255, 208, 194, 194),
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.pink[100],
                ),
                child: Icon(Icons.opacity, color: Colors.red),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Blood Sugar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: IconButton(
                  onPressed: () {
                    // Handle details action
                  },
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$bloodSugarTime',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '$bloodSugar mmHg',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  _showAddRecordDialog(
                      'http://192.168.1.107:8000/api/healthInfo/blood_sugar');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('+ Add Record'),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: const Color.fromARGB(255, 74, 142, 173),
          ),
          child: Row(
            children: [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 10),
              Text(
                'Heartbeat',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: IconButton(
                  onPressed: () async {
                    // onPressed: () async {
                    _showChartDialog(); // استدعاء الدالة لعرض الرسم البياني
                  },
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$heartbeatTime ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '$heartbeat bpm',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  _showAddRecordDialog(
                      'http://192.168.1.107:8000/api/healthInfo/heartbeat');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('+ Add Record'),
              ),
              // ElevatedButton(
              //   onPressed: () async {
              //     _showChartDialog(); // استدعاء الدالة لعرض الرسم البياني
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.blue,
              //   ),
              //   child: Text('Chart'),
              // ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Colors.lightBlue[100],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 25, // عرض الصورة
                height: 25, // ارتفاع الصورة
                child: Image.asset(
                  'assets/images/type-1.png',
                  // color: Color.fromARGB(
                  //     255, 235, 58, 58), // اللون الذي تريد تطبيقه
                ),
              ),
              SizedBox(width: 10),
              Text(
                'Type',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: IconButton(
                  onPressed: () {
                    // Handle details action
                  },
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$typeSugarTime ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '$type_diabetes',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () async {
                  _showAddRecordDialog(
                      'http://192.168.1.107:8000/api/healthInfo/type');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('+ Add Record'),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            color: Color.fromARGB(255, 216, 228, 149),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 25, // عرض الصورة
                height: 25, // ارتفاع الصورة
                child: Image.asset(
                  'assets/images/blood.png',
                  // color:
                  //     Color.fromARGB(255, 85, 88, 78), // اللون الذي تريد تطبيقه
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'HbAc1',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: IconButton(
                  onPressed: () {
                    // Handle details action
                  },
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$HbAc1SugarTime ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '$HbAc1 ms/mal',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _showAddRecordDialog(
                      'http://192.168.1.107:8000/api/healthInfo/hbac1');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('+ Add Record'),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: Color.fromARGB(255, 245, 224, 141),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 25, // عرض الصورة
                  height: 25, // ارتفاع الصورة
                  child: Image.asset(
                    'assets/images/oxygen.png',
                    // color: Color.fromARGB(
                    //     255, 85, 88, 78), // اللون الذي تريد تطبيقه
                  ),
                ),
                SizedBox(width: 8), // مسافة بين الصورة والنص
                Text(
                  'blood oxygen',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    onPressed: () {
                      // Handle details action
                    },
                    icon: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ),
              ],
            )),
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$blood_oxygenTime ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '$blood_oxygen %',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  _showAddRecordDialog(
                      'http://192.168.1.107:8000/api/healthInfo/blood_oxygen');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text('+ Add Record'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildHeartRateChart() {
  return LineChart(
    LineChartData(
      // تكوينات الرسم البياني هنا
      gridData: FlGridData(show: false),
      titlesData: FlTitlesData(show: false),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 70), // Replace with actual data points
            FlSpot(1, 75), // Replace with actual data points
            FlSpot(2, 80), // Replace with actual data points
            FlSpot(3, 72), // Replace with actual data points
            FlSpot(4, 78), // Replace with actual data points
            FlSpot(5, 76), // Replace with actual data points
          ],
          isCurved: true,
          color: Colors.blue,
          barWidth: 5,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: false),
        ),
      ],
    ),
  );
}
