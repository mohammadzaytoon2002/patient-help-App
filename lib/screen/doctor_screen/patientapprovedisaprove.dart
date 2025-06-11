import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/screen/doctor_screen/blood_oxygen.dart';
import 'package:watch3/screen/doctor_screen/bloodsugar.dart';
import 'package:watch3/screen/doctor_screen/heartbeat.dart';
import 'package:watch3/screen/doctor_screen/mypatient.dart';

// import 'package:watch3/screen/doctor_screen/patirntrequestpage.dart';

class PatientDetailsPage2 extends StatefulWidget {
  final int patientId;
  const PatientDetailsPage2({required this.patientId});

  @override
  _PatientDetailsPage2State createState() => _PatientDetailsPage2State();
}

class _PatientDetailsPage2State extends State<PatientDetailsPage2> {
  Map<String, dynamic>? patient;
  List<Map<String, String>> bloodSugarReports = [];
  List<Map<String, String>> heartbeatReports = [];
  List<Map<String, dynamic>> medications = [];
  String? token;
  List<Map<String, String>> bloodOxygenReports = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    //userId = prefs.getInt('userId');

    if (token != null && token!.isNotEmpty) {
      await _fetchPatientDetails();
      await _fetchReports();
      await _fetchMedications();
    } else {
      print('User is not logged in or token is null');
    }
  }

  Future<void> _fetchPatientDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.107:8000/api/from_doctor/requests'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        //  print('Response Data: $responseData'); // طباعة الاستجابة للتحقق منها

        if (responseData['requests'] != null &&
            responseData['requests'] is List) {
          final patients = responseData['requests'];

          final patientData = patients.firstWhere(
              (p) => p['user_id'] == widget.patientId,
              orElse: () => null);

          if (patientData != null) {
            setState(() {
              patient = patientData;
            });
          } else {
            print(
                'Patient not found'); // طباعة رسالة إذا لم يتم العثور على المريض
            setState(() {
              patient = null;
            });
          }
        } else {
          print(
              'Requests are null or not a list'); // طباعة رسالة إذا كانت الاستجابة لا تحتوي على طلبات
          setState(() {
            patient = null;
          });
        }
      } else {
        print('Error: ${response.statusCode}'); // طباعة رسالة الخطأ
        setState(() {
          patient = null;
        });
      }
    } catch (e) {
      print('Exception: $e'); // طباعة الاستثناء إذا حدث خطأ
      setState(() {
        patient = null;
      });
    }
  }

  Future<void> _fetchReports() async {
    try {
      // Fetch Heartbeat Reports
      final heartbeatResponse = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/healthreport/last_heartbeat_reports/${widget.patientId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (heartbeatResponse.statusCode == 200) {
        final Map<String, dynamic> heartbeatData =
            json.decode(heartbeatResponse.body);

        if (heartbeatData.containsKey('healthreport') &&
            heartbeatData['healthreport'] is Map) {
          final report = heartbeatData['healthreport'];
          setState(() {
            heartbeatReports = [
              {
                'id': report['id']?.toString() ?? '',
                'dateRange':
                    '${report['date_range_start']} - ${report['date_range_end']}',
                'generatedTime': report['created_at'] != null
                    ? DateFormat('h:mm a')
                        .format(DateTime.parse(report['created_at']))
                    : '',
              }
            ];
          });
        } else {
          print('No heartbeat reports found or data is not a map.');
        }
      } else {
        print(
            'Failed to fetch heartbeat reports: ${heartbeatResponse.statusCode}');
      }

      // Fetch Blood Sugar Reports
      final bloodSugarResponse = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/healthreport/last_blood_sugar_reports/${widget.patientId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (bloodSugarResponse.statusCode == 200) {
        final Map<String, dynamic> bloodSugarData =
            json.decode(bloodSugarResponse.body);

        if (bloodSugarData.containsKey('healthreport') &&
            bloodSugarData['healthreport'] is Map) {
          final report = bloodSugarData['healthreport'];
          setState(() {
            bloodSugarReports = [
              {
                'id': report['id']?.toString() ?? '',
                'dateRange':
                    '${report['date_range_start']} - ${report['date_range_end']}',
                'generatedTime': report['created_at'] != null
                    ? DateFormat('h:mm a')
                        .format(DateTime.parse(report['created_at']))
                    : '',
              }
            ];
          });
        } else {
          print('No blood sugar reports found or data is not a map.');
        }
      } else {
        print(
            'Failed to fetch blood sugar reports: ${bloodSugarResponse.statusCode}');
      }

      // Fetch Blood Oxygen Reports
      final bloodOxygenResponse = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/healthreport/last_blood_oxygen_reports/${widget.patientId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (bloodOxygenResponse.statusCode == 200) {
        final Map<String, dynamic> bloodOxygenData =
            json.decode(bloodOxygenResponse.body);

        if (bloodOxygenData.containsKey('healthreport') &&
            bloodOxygenData['healthreport'] is Map) {
          final report = bloodOxygenData['healthreport'];
          setState(() {
            bloodOxygenReports = [
              {
                'id': report['id']?.toString() ?? '',
                'dateRange':
                    '${report['date_range_start']} - ${report['date_range_end']}',
                'generatedTime': report['created_at'] != null
                    ? DateFormat('h:mm a')
                        .format(DateTime.parse(report['created_at']))
                    : '',
              }
            ];
          });
        } else {
          print('No blood oxygen reports found or data is not a map.');
        }
      } else {
        print(
            'Failed to fetch blood oxygen reports: ${bloodOxygenResponse.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching reports: $e');
    }
  }

  Future<void> _fetchMedications() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/nearest_medication/${widget.patientId}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        //  print('medicationsData: $data');
        if (data.containsKey('medication') && data['medication'] is Map) {
          final med = data['medication'];
          setState(() {
            medications = [
              {
                'name': med['name'] ?? '',
                'pill': med['pill']?.toString() ?? '',
                'unit': med['unit'] ?? '',
                'freq': med['freq'] ?? '',
                'time': med['time'] ?? '',
                'timeRangeStart': med['time_range_start'] ?? '',
                'timeRangeEnd': med['time_range_end'] ?? '',
              }
            ];
          });
        } else {
          print('No medications found or data is not a map.');
        }
      } else {
        print('Failed to fetch medications: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception while fetching medications: $e');
    }
  }

  Future<void> _approvePatient() async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.1.107:8000/api/from_doctor/approve/${widget.patientId}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message'] ?? 'Approved'),
        backgroundColor: Colors.green,
      ));
    }
  }

  Future<void> _disapprovePatient() async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.1.107:8000/api/from_doctor/disapprove/${widget.patientId}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(data['message'] ?? 'Disapproved'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _showDisapproveDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Disapprove ?'),
          content: Text('Are you sure you want to disapprove this patient?'),
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
                _disapprovePatient();
              },
              child: Text('Yes', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
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
                'The requests sent to me',
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
              child: Column(
                children: [
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
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
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
                          SizedBox(height: 16),
                          Text(
                            'Heartbeat Reports:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          heartbeatReports.isNotEmpty
                              ? Column(
                                  children: heartbeatReports
                                      .map((report) => ReportContainer(
                                            id: report['id']!,
                                            dateRange: report['dateRange']!,
                                            generatedTime:
                                                report['generatedTime']!,
                                            color: Colors.blue,
                                            type: 'heartbeat',
                                            onDetailsPressed: _navigateToReport,
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
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          bloodSugarReports.isNotEmpty
                              ? Column(
                                  children: bloodSugarReports
                                      .map((report) => ReportContainer(
                                            id: report['id']!,
                                            dateRange: report['dateRange']!,
                                            generatedTime:
                                                report['generatedTime']!,
                                            color: Colors.orange,
                                            type: 'blood_sugar',
                                            onDetailsPressed: _navigateToReport,
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
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
                          bloodOxygenReports.isNotEmpty
                              ? Column(
                                  children: bloodOxygenReports
                                      .map((report) => ReportContainer(
                                            id: report['id']!,
                                            dateRange: report['dateRange']!,
                                            generatedTime:
                                                report['generatedTime']!,
                                            color: Colors.green,
                                            type: 'blood_oxygen',
                                            onDetailsPressed: _navigateToReport,
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
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                              vertical: 8, horizontal: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.blueAccent,
                                                  Colors.lightBlueAccent
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            ),
                                            child: ListTile(
                                              contentPadding:
                                                  EdgeInsets.all(16),
                                              title: Text(
                                                med['name']!,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Pill: ${med['pill']} ${med['unit']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Frequency: ${med['freq']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Time: ${med['time']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white70,
                                                    ),
                                                  ),
                                                  Text(
                                                    'Time Range: ${med['timeRangeStart']} - ${med['timeRangeEnd']}',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.white70,
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
                                      style: TextStyle(color: Colors.red),
                                    ),
                            ],
                          )
                        ]),
                  ),
                ],
              ),
            ),
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
                'Disapprove',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, minimumSize: Size(150, 50)),
              onPressed: _approvePatient,
              child: Text(
                'Approve',
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
