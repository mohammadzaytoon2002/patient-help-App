import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/screen/report/blood_oxygenreport.dart';
import 'package:watch3/screen/report/bloodsuqarreport.dart';
import 'package:watch3/screen/report/heartbeatreport.dart';

class RepositoryPage extends StatelessWidget {
  Future<List<Map<String, String>>> _loadBloodSugarReports(String token) async {
    final bloodSugarResponse = await http.get(
      Uri.parse(
          'http://192.168.1.107:8000/api/healthreport/blood_sugar_reports'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (bloodSugarResponse.statusCode == 200) {
      final Map<String, dynamic> bloodSugarData =
          json.decode(bloodSugarResponse.body);

      if (bloodSugarData.containsKey('healthreport') &&
          bloodSugarData['healthreport'] != null) {
        return (bloodSugarData['healthreport'] as List).map((report) {
          return {
            'id': report['id'].toString(),
            'dateRange':
                '${report['date_range_start']} - ${report['date_range_end']}',
            'generatedTime': DateFormat('h:mm a')
                .format(DateTime.parse(report['created_at'])),
            'type': 'blood_sugar',
          };
        }).toList();
      }
    }

    return [];
  }

  Future<List<Map<String, String>>> _loadHeartbeatReports(String token) async {
    final heartbeatResponse = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/healthreport/heartbeat_reports'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (heartbeatResponse.statusCode == 200) {
      final Map<String, dynamic> heartbeatData =
          json.decode(heartbeatResponse.body);

      if (heartbeatData.containsKey('healthreport') &&
          heartbeatData['healthreport'] != null) {
        return (heartbeatData['healthreport'] as List).map((report) {
          return {
            'id': report['id'].toString(),
            'dateRange':
                '${report['date_range_start']} - ${report['date_range_end']}',
            'generatedTime': DateFormat('h:mm a')
                .format(DateTime.parse(report['created_at'])),
            'type': 'heartbeat',
          };
        }).toList();
      }
    }

    return [];
  }

  Future<List<Map<String, String>>> _loadBloodOxygenReports(
      String token) async {
    final bloodOxygenResponse = await http.get(
      Uri.parse(
          'http://192.168.1.107:8000/api/healthreport/blood_oxygen_reports'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (bloodOxygenResponse.statusCode == 200) {
      final Map<String, dynamic> bloodOxygenData =
          json.decode(bloodOxygenResponse.body);

      if (bloodOxygenData.containsKey('healthreport') &&
          bloodOxygenData['healthreport'] != null) {
        return (bloodOxygenData['healthreport'] as List).map((report) {
          return {
            'id': report['id'].toString(),
            'dateRange':
                '${report['date_range_start']} - ${report['date_range_end']}',
            'generatedTime': DateFormat('h:mm a')
                .format(DateTime.parse(report['created_at'])),
            'type': 'blood_oxygen',
          };
        }).toList();
      }
    }

    return [];
  }

  Future<void> _deleteReport(
      BuildContext context, String id, String token) async {
    final response = await http.delete(
      Uri.parse('http://192.168.1.107:8000/api/healthreport/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('Report deleted successfully.'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to delete the report.'),
        ),
      );
    }
  }

  void _navigateToReport(BuildContext context, String id, String type) {
    if (type == 'blood_sugar') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BloodSugarReportPage(reportId: id),
        ),
      );
    } else if (type == 'heartbeat') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HeartbeatReportPage(reportId: id),
        ),
      );
    } else if (type == 'blood_oxygen') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BloodOxygenReportPage(reportId: id),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'The repository of reports',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<String?>(
          future: _loadToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('Failed to load token'));
            } else {
              final token = snapshot.data!;
              return FutureBuilder<List<Map<String, String>>>(
                future: _loadBloodSugarReports(token),
                builder: (context, bloodSugarSnapshot) {
                  if (bloodSugarSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (bloodSugarSnapshot.hasError) {
                    return Center(
                        child: Text('Error: ${bloodSugarSnapshot.error}'));
                  } else {
                    final bloodSugarReports = bloodSugarSnapshot.data ?? [];

                    return FutureBuilder<List<Map<String, String>>>(
                      future: _loadHeartbeatReports(token),
                      builder: (context, heartbeatSnapshot) {
                        if (heartbeatSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (heartbeatSnapshot.hasError) {
                          return Center(
                              child: Text('Error: ${heartbeatSnapshot.error}'));
                        } else {
                          final heartbeatReports = heartbeatSnapshot.data ?? [];

                          return FutureBuilder<List<Map<String, String>>>(
                            future: _loadBloodOxygenReports(token),
                            builder: (context, bloodOxygenSnapshot) {
                              if (bloodOxygenSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (bloodOxygenSnapshot.hasError) {
                                return Center(
                                    child: Text(
                                        'Error: ${bloodOxygenSnapshot.error}'));
                              } else {
                                final bloodOxygenReports =
                                    bloodOxygenSnapshot.data ?? [];

                                return SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Blood sugar reports:',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      ...bloodSugarReports.map(
                                        (report) => ReportContainer(
                                          id: report['id']!,
                                          dateRange: report['dateRange']!,
                                          generatedTime:
                                              report['generatedTime']!,
                                          color: const Color.fromARGB(
                                              255, 235, 169, 192),
                                          type: report['type']!,
                                          onDetailsPressed: () {
                                            _navigateToReport(context,
                                                report['id']!, report['type']!);
                                          },
                                          onDeletePressed: () {
                                            _deleteReport(
                                                context, report['id']!, token);
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Heartbeat reports:',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      ...heartbeatReports.map(
                                        (report) => ReportContainer(
                                          id: report['id']!,
                                          dateRange: report['dateRange']!,
                                          generatedTime:
                                              report['generatedTime']!,
                                          color: Color.fromARGB(
                                              255, 156, 197, 255),
                                          type: report['type']!,
                                          onDetailsPressed: () {
                                            _navigateToReport(context,
                                                report['id']!, report['type']!);
                                          },
                                          onDeletePressed: () {
                                            _deleteReport(
                                                context, report['id']!, token);
                                          },
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Blood oxygen reports:',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 20),
                                      ...bloodOxygenReports.map(
                                        (report) => ReportContainer(
                                          id: report['id']!,
                                          dateRange: report['dateRange']!,
                                          generatedTime:
                                              report['generatedTime']!,
                                          color:
                                              Color.fromARGB(255, 232, 141, 45),
                                          type: report['type']!,
                                          onDetailsPressed: () {
                                            _navigateToReport(context,
                                                report['id']!, report['type']!);
                                          },
                                          onDeletePressed: () {
                                            _deleteReport(
                                                context, report['id']!, token);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                          );
                        }
                      },
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<String?> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}

class ReportContainer extends StatelessWidget {
  final String id;
  final String dateRange;
  final String generatedTime;
  final Color color;
  final String type;
  final VoidCallback onDetailsPressed;
  final VoidCallback onDeletePressed;

  const ReportContainer({
    required this.id,
    required this.dateRange,
    required this.generatedTime,
    required this.color,
    required this.type,
    required this.onDetailsPressed,
    required this.onDeletePressed,
  });

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete this report?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Yes"),
              onPressed: onDeletePressed,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Text(
              'Date range: $dateRange',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'The report was generated at $generatedTime.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.red,
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onDetailsPressed,
                  child: Text(
                    'More details',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
