import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BloodOxygenReportPage extends StatefulWidget {
  final String reportId;

  BloodOxygenReportPage({required this.reportId});

  @override
  _BloodOxygenReportPageState createState() => _BloodOxygenReportPageState();
}

class _BloodOxygenReportPageState extends State<BloodOxygenReportPage> {
  late Future<String?> _loadTokenFuture;
  late Future<Map<String, dynamic>> _fetchReportFuture;

  @override
  void initState() {
    super.initState();
    _loadTokenFuture = _loadToken();
  }

  Future<String?> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> fetchReportData(
      String reportId, String token) async {
    final response = await http.get(
      Uri.parse(
          'http://192.168.1.107:8000/api/healthreport/onereport/$reportId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['healthreport'];
    } else {
      print("Failed to load report data. Status code: ${response.statusCode}");
      print("Response body: ${response.body}");
      throw Exception(
          'Failed to load report data. Status code: ${response.statusCode}, Response body: ${response.body}');
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
      body: FutureBuilder<String?>(
        future: _loadTokenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Failed to load token'));
          } else {
            final token = snapshot.data!;
            _fetchReportFuture = fetchReportData(widget.reportId, token);

            return FutureBuilder<Map<String, dynamic>>(
              future: _fetchReportFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No report data available'));
                } else {
                  final report = snapshot.data!;
                  final dateRangeStart = report['date_range_start'];
                  final dateRangeEnd = report['date_range_end'];
                  final healthInfos = report['health_infos'] as List;

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
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Date range: $dateRangeStart - $dateRangeEnd'),
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
                            'Blood oxygen levels are measured as a percentage. The following ranges are used to interpret blood oxygen levels:',
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
                                style: TextStyle(color: Colors.blue),
                              ),
                              Text(
                                'above 100%',
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          ...healthInfos.map((info) {
                            final createdAt = DateFormat('MMM dd, yyyy')
                                .format(DateTime.parse(info['created_at']));
                            final value = info['value'];
                            final status = _getOxygenStatus(value);
                            final method =
                                'Pulse Oximeter'; // Assuming method is 'Pulse Oximeter'

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  createdAt,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Table(
                                  border: TableBorder.all(color: Colors.blue),
                                  columnWidths: {
                                    0: FlexColumnWidth(1),
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(1),
                                    3: FlexColumnWidth(1),
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
                                            '%',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Method',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TableRow(children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(DateFormat('hh:mm a')
                                            .format(DateTime.parse(
                                                info['created_at']))),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                              color: _getStatusColor(status)),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('$value'),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(method),
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
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  String _getOxygenStatus(int value) {
    if (value < 90) {
      return 'Low';
    } else if (value <= 100) {
      return 'Normal';
    } else {
      return 'High';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Low':
        return Colors.red;
      case 'Normal':
        return Colors.green;
      case 'High':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }
}
