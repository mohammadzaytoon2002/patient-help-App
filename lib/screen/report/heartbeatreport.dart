import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HeartbeatReportPage extends StatelessWidget {
  final String reportId;

  HeartbeatReportPage({required this.reportId});

  Future<Map<String, dynamic>> _loadReportData(
      String token, String reportId) async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.107:8000/api/healthreport/onereport/$reportId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['healthreport'];
    } else {
      throw Exception('Failed to load report data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _loadToken(),
      builder: (context, tokenSnapshot) {
        if (tokenSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Generating report'),
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (tokenSnapshot.hasError || tokenSnapshot.data == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Error'),
            ),
            body: Center(child: Text('Failed to load token')),
          );
        } else {
          final token = tokenSnapshot.data!;
          return FutureBuilder<Map<String, dynamic>>(
            future: _loadReportData(token, reportId),
            builder: (context, reportSnapshot) {
              if (reportSnapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Generating report'),
                  ),
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (reportSnapshot.hasError) {
                return Scaffold(
                  appBar: AppBar(
                    title: Text('Error'),
                  ),
                  body: Center(child: Text('Failed to load report data')),
                );
              } else {
                final reportData = reportSnapshot.data!;
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
                                  'HEARTBEAT REPORT',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                              'Date range: ${reportData['date_range_start']} - ${reportData['date_range_end']}'),
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
                                  DateFormat('MMM dd, yyyy').format(
                                      DateTime.parse(info['created_at'])),
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
                                      decoration:
                                          BoxDecoration(color: Colors.blue),
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Timing',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Status',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'bpm',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(DateFormat('hh:mm a')
                                              .format(DateTime.parse(
                                                  info['created_at']))),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            info['status'],
                                            style: TextStyle(
                                                color: _getStatusColor(
                                                    info['status'])),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(info['value'].toString()),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                              ],
                            );
                          }).toList(),
                          Text(
                            'Note: All rights reserved for our application Diabetes Gene FP. Please do not share your health data except with your doctor. Click the Save button to save your health data.',
                            style: TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Process date: Jun 2024',
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          );
        }
      },
    );
  }

  Future<String?> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
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
