import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/componant/shape%20copy.dart';
import 'package:watch3/pusher/chat_pusher.dart';
import 'package:watch3/screen/doctor_screen/blood_oxygen.dart';
import 'package:watch3/screen/doctor_screen/bloodsugar.dart';
import 'package:watch3/screen/doctor_screen/heartbeat.dart';
import 'package:watch3/screen/doctor_screen/patientapprovedisaprove.dart';
import 'package:watch3/screen/doctor_screen/prediction_patient.dart';

class PatientDetailsPage extends StatefulWidget {
  final int patientId;
  const PatientDetailsPage({required this.patientId});

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Map<String, dynamic>? patient;
  List<Map<String, String>> bloodSugarReports = [];
  List<Map<String, String>> heartbeatReports = [];
  List<Map<String, String>> bloodOxygenReports = [];
  List<Map<String, dynamic>> medications = [];
  String? token;
  int? doctorid;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null && token!.isNotEmpty) {
      await fetchPatientIdAndDetails();
      await _fetchReports();
      await _fetchMedications();
      await fetchChatIdIfAvailable();
    } else {
      print('User is not logged in or token is null');
    }
  }

  Future<void> fetchPatientIdAndDetails() async {
    doctorid = await fetchdoctortId();
    if (doctorid != null) {
      await _fetchPatientDetails();
    } else {
      setState(() {
        // Handle error
      });
    }
  }

  Future<int?> fetchdoctortId() async {
    final url = 'http://192.168.1.107:8000/api/users/me';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData['user']['id'];
    } else {
      return null;
    }
  }

  Future<void> _fetchPatientDetails() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/from_doctor/patients'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['patients'] != null) {
        final patients = responseData['patients'];
        final patientData = patients.firstWhere(
          (p) => p['user_id'] == widget.patientId,
          orElse: () => null,
        );

        if (patientData != null) {
          setState(() {
            patient = patientData;
          });
        }
      }
    }
  }

  Future<void> _fetchReports() async {
    try {
      final response1 = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/healthreport/heartbeat_reports/${widget.patientId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final response2 = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/healthreport/blood_sugar_reports/${widget.patientId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final response3 = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/healthreport/blood_oxygen_reports/${widget.patientId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      _processResponse(response1, 'heartbeat');
      _processResponse(response2, 'blood_sugar');
      _processResponse(response3, 'blood_oxygen');
    } catch (e) {
      print('Exception while fetching reports: $e');
    }
  }

  void _processResponse(http.Response response, String type) {
    if (response.statusCode == 200) {
      final List<dynamic> reportsData =
          json.decode(response.body)['healthreport'];
      final List<Map<String, String>> reports = reportsData.map((report) {
        return {
          'id': report['id'].toString(),
          'dateRange':
              '${report['date_range_start']} - ${report['date_range_end']}',
          'generatedTime':
              DateFormat('h:mm a').format(DateTime.parse(report['created_at'])),
        };
      }).toList();

      setState(() {
        if (type == 'heartbeat') {
          heartbeatReports = reports;
        } else if (type == 'blood_sugar') {
          bloodSugarReports = reports;
        } else if (type == 'blood_oxygen') {
          bloodOxygenReports = reports;
        }
      });
    } else {
      print('Failed to fetch $type reports');
    }
  }

  Future<void> _fetchMedications() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/medications/${widget.patientId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['medications'];
        setState(() {
          medications = data.map((med) {
            return {
              'name': med['name'] ?? '',
              'pill': med['pill']?.toString() ?? '',
              'unit': med['unit'] ?? '',
              'freq': med['freq'] ?? '',
              'time': med['time'] ?? '',
              'timeRangeStart': med['time_range_start'] ?? '',
              'timeRangeEnd': med['time_range_end'] ?? '',
            };
          }).toList();
        });
      } else {
        print('Failed to fetch medications');
      }
    } catch (e) {
      print('Exception while fetching medications: $e');
    }
  }

  Future<void> _delete() async {
    final response = await http.delete(
      Uri.parse(
          'http://192.168.1.107:8000/api/from_doctor/deletpatient/${widget.patientId}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete patient')),
      );
    }
  }

  // void _message() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ChatPage(
  //         doctorId: widget.patientId,
  //       ),
  //     ),
  //   );
  // }

  void _showDisapproveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete ?'),
          content: Text('Are you sure you want to delete this patient?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _delete();
              },
              child: Text('Yes', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchChatIdIfAvailable() async {
    final url = 'http://192.168.1.107:8000/api/chat';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData is Map && responseData.containsKey('chats')) {
        List chats = responseData['chats'];
        if (chats.isNotEmpty) {
          final chat = chats.firstWhere(
            (chat) => chat['participants'].any(
              (participant) => participant['user']['id'] == widget.patientId,
            ),
            orElse: () => null,
          );
          if (chat != null) {
            final chatId = chat['id'].toString();
            // Optionally handle chatId if needed
          }
        }
      }
    }
  }

  void _navigateToReport(String type, int reportId) {
    if (type == 'blood_sugar') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BloodSugarReportPagedoc(
            patientId: widget.patientId,
            reportId: reportId.toString(),
          ),
        ),
      );
    } else if (type == 'heartbeat') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HeartbeatReportPagedoc(
            patientId: widget.patientId,
            reportId: reportId.toString(),
          ),
        ),
      );
    } else if (type == 'blood_oxygen') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BloodOxygenReportPage(
            patientId: widget.patientId,
            reportId: reportId.toString(),
          ),
        ),
      );
    }
  }

  Future<void> fetchChatIdAndNavigate() async {
    if (doctorid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Patient ID not found'),
        ),
      );
      return;
    }

    final url = 'http://192.168.1.107:8000/api/chat';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData is Map && responseData.containsKey('chats')) {
        List chats = responseData['chats'];
        if (chats.isNotEmpty) {
          final chat = chats.firstWhere(
            (chat) => chat['participants'].any(
              (participant) => participant['user']['id'] == widget.patientId,
            ),
            orElse: () => null,
          );
          if (chat != null) {
            final int chatId = chat['id'];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  chatId: chatId,
                  userId: doctorid!,
                  token: token!,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('No chat found with the specified doctor'),
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No chats available'),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected response format'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load chat id: ${response.body}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 3, 88, 128),
          shape: CustomShapeBorder(),
          toolbarHeight: 100.0,
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
                'My patient',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
              // Opacity(
              //   opacity: 0.5, // لجعل الشعار شفافًا
              //   child: Image.asset(
              //     'assets/images/logo.png', // المسار إلى صورة الشعار
              //     height: 40.0, // ضبط ارتفاع الشعار
              //   ),
              // ),
            ],
          ),
        ),
      ),
      body: patient == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(children: [
              // Header and patient details
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipPath(
                    clipper: CustomShapeClipper(),
                    child: Container(
                      height: 150,
                      color: Color.fromARGB(255, 3, 88, 128),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: double.infinity,
                                height: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      'http://192.168.1.107:8000${patient!['user']['picture']}',
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                        'http://192.168.1.107:8000${patient!['user']['picture']}',
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),
              Text(
                '${patient!['user']['first_name']} ${patient!['user']['last_name']}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
              ),
              Text(
                'A patient with Type ${patient!['diabets_type'] ?? 'N/A'} diabetes',
                style: TextStyle(fontSize: 16.0),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18.0),
                        ),
                        Text(
                          patient!['desc'] ?? 'No description available',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        // Reports
                        ListTile(
                          title: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PredictionResultPage(
                                        patientId: widget.patientId)),
                              );
                            },
                            child: Text('Prediction Details'),
                          ),
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Heartbeat Reports:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  heartbeatReports.isNotEmpty
                                      ? Column(
                                          children: heartbeatReports
                                              .map((report) => ReportContainer(
                                                    id: report['id']!,
                                                    dateRange:
                                                        report['dateRange']!,
                                                    generatedTime: report[
                                                        'generatedTime']!,
                                                    color: Colors.blue,
                                                    type: 'heartbeat',
                                                    onDetailsPressed:
                                                        _navigateToReport,
                                                  ))
                                              .toList(),
                                        )
                                      : Text(
                                          'No heartbeat reports available',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                  SizedBox(height: 16),
                                  SizedBox(height: 16),
                                  Text(
                                    'Blood Sugar reports:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  bloodSugarReports.isNotEmpty
                                      ? Column(
                                          children: bloodSugarReports
                                              .map((report) => ReportContainer(
                                                    id: report['id']!,
                                                    dateRange:
                                                        report['dateRange']!,
                                                    generatedTime: report[
                                                        'generatedTime']!,
                                                    color: Colors.orange,
                                                    type: 'blood_sugar',
                                                    onDetailsPressed:
                                                        _navigateToReport,
                                                  ))
                                              .toList(),
                                        )
                                      : Text(
                                          'No blood sugar reports available',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                  //  SizedBox(height: 16),
                                  SizedBox(height: 16),
                                  Text(
                                    'Blood Oxygen reports:',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  bloodOxygenReports.isNotEmpty
                                      ? Column(
                                          children: bloodOxygenReports
                                              .map((report) => ReportContainer(
                                                    id: report['id']!,
                                                    dateRange:
                                                        report['dateRange']!,
                                                    generatedTime: report[
                                                        'generatedTime']!,
                                                    color: Colors.green,
                                                    type: 'blood_oxygen',
                                                    onDetailsPressed:
                                                        _navigateToReport,
                                                  ))
                                              .toList(),
                                        )
                                      : Text(
                                          'No blood oxygen reports available',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                  SizedBox(height: 16),

                                  SizedBox(height: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Medications
                                      Text(
                                        'Medications:',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      medications.isNotEmpty
                                          ? Column(
                                              children: medications.map((med) {
                                                return Card(
                                                  elevation: 4,
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.blueAccent,
                                                          Colors.lightBlueAccent
                                                        ],
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                      ),
                                                    ),
                                                    child: ListTile(
                                                      contentPadding:
                                                          EdgeInsets.all(16),
                                                      title: Text(
                                                        med['name']!,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      subtitle: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Pill: ${med['pill']} ${med['unit']}',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Frequency: ${med['freq']}',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Time: ${med['time']}',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Time Range: ${med['timeRangeStart']} - ${med['timeRangeEnd']}',
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors
                                                                  .white70,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      trailing: Icon(
                                                        Icons.medical_services,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            )
                                          : Text(
                                              'No medications available',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                    ],
                                  )
                                ]),
                          ),
                        ),
                      ]))
            ])),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, minimumSize: Size(150, 50)),
              onPressed: _showDisapproveDialog,
              child: Text(
                'Delete',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, minimumSize: Size(150, 50)),
              onPressed: fetchChatIdAndNavigate,
              child: Text(
                'message',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReportContainer extends StatelessWidget {
  final String id;
  final String dateRange;
  final String generatedTime;
  final Color color;
  final String type;
  final Function(String, int) onDetailsPressed;

  const ReportContainer({
    required this.id,
    required this.dateRange,
    required this.generatedTime,
    required this.color,
    required this.type,
    required this.onDetailsPressed,
  });

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
                ElevatedButton(
                  onPressed: () => onDetailsPressed(type, int.parse(id)),
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

class CustomShapeBorder extends ContinuousRectangleBorder {}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.75);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.75,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
