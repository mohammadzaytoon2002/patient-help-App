import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BloodOxygenReportPage extends StatefulWidget {
  final int patientId;
  final String reportId;

  const BloodOxygenReportPage({
    required this.patientId,
    required this.reportId,
  });

  @override
  _BloodOxygenReportPageState createState() => _BloodOxygenReportPageState();
}

class _BloodOxygenReportPageState extends State<BloodOxygenReportPage> {
  Future<Map<String, dynamic>>? _fetchReportFuture;
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
        _fetchReportFuture = _fetchReport();
      });
    } else {
      print('User is not logged in or token/userId is null');
    }
  }

  Future<Map<String, dynamic>> _fetchReport() async {
    final url =
        'http://192.168.1.107:8000/api/from_doctor/healthreport/patient/${widget.patientId}/onereport/${widget.reportId}';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData != null && responseData.containsKey('healthreport')) {
        return responseData['healthreport'];
      } else {
        throw Exception('Report data is empty or malformed');
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
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchReportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.data == null) {
            return Center(
              child: Text('No report data available.'),
            );
          } else {
            return _buildReportWidget(
                snapshot.data!); // Accessing snapshot.data directly
          }
        },
      ),
    );
  }

  Widget _buildReportWidget(Map<String, dynamic> reportData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
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
                    'BLOOD OXYGEN REPORT',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
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
                        fontSize: 18),
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
              'Blood oxygen levels can vary based on various factors. Regular monitoring is important for maintaining overall health.',
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '• Low: ',
                  style: TextStyle(color: Colors.red),
                ),
                Text(
                  'less than 90%',
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '• Normal: ',
                  style: TextStyle(color: Colors.green),
                ),
                Text(
                  '90-100%',
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  '• High: ',
                  style: TextStyle(color: Colors.orange),
                ),
                Text(
                  'above 100%',
                ),
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
                          child: Text(DateFormat('hh:mm a')
                              .format(DateTime.parse(info['created_at']))),
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
              'Note: All rights reserved for our application. Please do not share your health data except with your doctor. Click the Save button to save your health data.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8),
            Text(
              'Process date: Jun 2024',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Low':
        return Colors.red;
      case 'Normal':
        return Colors.green;
      case 'High':
        return Colors.orange;
      default:
        return Colors.black;
    }
  }
}
