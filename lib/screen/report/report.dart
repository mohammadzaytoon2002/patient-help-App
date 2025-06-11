import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:watch3/screen/report/allreport.dart';
import 'package:watch3/screen/report/blood_oxygenreport.dart';
import 'package:watch3/screen/report/bloodsuqarreport.dart';
import 'package:watch3/screen/report/heartbeatreport.dart';

void main() {
  runApp(MyApp1());
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Report App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GeneratingReportPage(),
    );
  }
}

class GeneratingReportPage extends StatefulWidget {
  @override
  _GeneratingReportPageState createState() => _GeneratingReportPageState();
}

class _GeneratingReportPageState extends State<GeneratingReportPage> {
  DateTime? startDate;
  DateTime? endDate;
  String? selectedReportType;
  String? token;

  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          startDate = picked;
          startController.text = DateFormat('dd/MM/yyyy').format(startDate!);
        } else {
          endDate = picked;
          endController.text = DateFormat('dd/MM/yyyy').format(endDate!);
        }
      });
    }
  }

  Future<void> _generateReport() async {
    if (startDate == null || endDate == null || selectedReportType == null) {
      // Display an error message or toast
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final String apiUrl = 'http://192.168.1.107:8000/api/healthreport';
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'type': selectedReportType,
        'date_range_start': DateFormat('yyyy-MM-dd').format(startDate!),
        'date_range_end': DateFormat('yyyy-MM-dd').format(endDate!),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Successfully generated report
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                responseData['message'] ?? 'Report generated successfully')),
      );

      final String reportId = responseData['health_report']['id']
          .toString(); // Assuming the response contains an 'id' field

      // Navigate to the respective report page
      if (selectedReportType == 'heartbeat') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HeartbeatReportPage(reportId: reportId),
          ),
        );
      } else if (selectedReportType == 'blood_sugar') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BloodSugarReportPage(reportId: reportId),
          ),
        );
      } else if (selectedReportType == 'blood_oxygen') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BloodOxygenReportPage(reportId: reportId),
          ),
        );
      }
    } else {
      // Error generating report
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate report')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
          'Generating report',
          style: TextStyle(
            color: Colors.white,
          ),
        )),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Time range',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, true),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: startController,
                          decoration: InputDecoration(
                            labelText: 'Start',
                            hintText: 'Select Date',
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _selectDate(context, false),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: endController,
                          decoration: InputDecoration(
                            labelText: 'To',
                            hintText: 'Select Date',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Text('Report type',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Text('Blood sugar',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    Image.asset(
                      'assets/images/sugericon.png',
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
                leading: Radio(
                  value: 'blood_sugar',
                  groupValue: selectedReportType,
                  onChanged: (value) {
                    setState(() {
                      selectedReportType = value.toString();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Text('Heartbeat',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    Icon(Icons.favorite, color: Colors.red),
                  ],
                ),
                leading: Radio(
                  value: 'heartbeat',
                  groupValue: selectedReportType,
                  onChanged: (value) {
                    setState(() {
                      selectedReportType = value.toString();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: ListTile(
                title: Row(
                  children: [
                    Text('Blood Oxygen',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    Image.asset(
                      'assets/images/oxygen.png',
                      height: 24,
                      width: 24,
                      color: Colors.red,
                    ),
                  ],
                ),
                leading: Radio(
                  value: 'blood_oxygen',
                  groupValue: selectedReportType,
                  onChanged: (value) {
                    setState(() {
                      selectedReportType = value.toString();
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 175),
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RepositoryPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Click to view all reports',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 1,
                    width: 160,
                    color: Colors.blue,
                    margin: EdgeInsets.only(top: 4),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(350, 50),
                ),
                onPressed: _generateReport,
                child: Text('Generate Report',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
