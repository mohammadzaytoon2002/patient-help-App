import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HeartbeatReportPagedoc extends StatefulWidget {
  final int patientId;
  final String reportId;

  const HeartbeatReportPagedoc({
    required this.patientId,
    required this.reportId,
  });

  @override
  _HeartbeatReportPagedocState createState() => _HeartbeatReportPagedocState();
}

class _HeartbeatReportPagedocState extends State<HeartbeatReportPagedoc> {
  late Future<Map<String, dynamic>> _futureReport;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null && token!.isNotEmpty) {
      setState(() {
        _futureReport = _fetchReport();
      });
    } else {
      print('User is not logged in or token is null');
    }
  }

  Future<Map<String, dynamic>> _fetchReport() async {
    final url =
        'http://192.168.1.107:8000/api/from_doctor/healthreport/patient/${widget.patientId}/onereport/${widget.reportId}';
    print('Fetching report from URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null && responseData['healthreport'] != null) {
        return responseData['healthreport'];
      } else {
        throw Exception('Failed to fetch report data');
      }
    } else {
      throw Exception('Failed to fetch report: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.white,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Generating report',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<Map<String, dynamic>>(
          future: _futureReport,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final reportData = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 50,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'HEARTBEAT REPORT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Date range: ${reportData['date_range_start']} - ${reportData['date_range_end']}',
                    ),
                    SizedBox(height: 16),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'OVERVIEW',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                          ),
                          Container(
                            height: 2,
                            color: Colors.blue,
                            width: double.infinity,
                            margin: const EdgeInsets.only(top: 8.0),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'For accurate heart rate measurement, it\'s best to be in a calm position, either sitting or lying down. Physical activity may affect readings, so relaxation is essential for precise results.',
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '• Bradycardia: ',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text('less than 60 bpm'),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '• Normal: ',
                          style: TextStyle(color: Colors.green),
                        ),
                        Text('60-100 bpm'),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '• Tachycardia: ',
                          style: TextStyle(color: Colors.orange),
                        ),
                        Text('100-139 bpm'),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '• Sport: ',
                          style: TextStyle(
                              color: Color.fromARGB(255, 158, 60, 54)),
                        ),
                        Text('140-160 bpm'),
                      ],
                    ),
                    SizedBox(height: 16),
                    ...reportData['health_infos'].map<Widget>((info) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMM dd, yyyy')
                                .format(DateTime.parse(info['created_at'])),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Table(
                            border: TableBorder.all(color: Colors.blue),
                            columnWidths: {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(1),
                              2: FlexColumnWidth(1),
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(color: Colors.blue),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Timing',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Status',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'bpm',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              TableRow(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(DateFormat('hh:mm a').format(
                                      DateTime.parse(info['created_at']))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    info['status'],
                                    style: TextStyle(
                                        color: _getStatusColor(info['status'])),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(info['value'].toString()),
                                ),
                              ]),
                            ],
                          ),
                          SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                    Text(
                      'Note: All rights reserved for our application Diabetes Gene FP. Please do not share your health data except with your doctor. Click the Save button to save your health data.',
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Process date: Jun 2024',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('No report data'));
            }
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Bradycardia':
        return Colors.red;
      case 'Normal':
        return Colors.green;
      case 'Tachycardia':
        return Colors.orange;
      case 'Sport':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
