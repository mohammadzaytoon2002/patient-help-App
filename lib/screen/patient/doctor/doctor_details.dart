import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorDetailPage extends StatefulWidget {
  final int doctorId;

  DoctorDetailPage({required this.doctorId});

  @override
  _DoctorDetailPageState createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  Map doctor = {};
  bool requested = false;
  String? token;
  String errorMessage = '';
  int doctorMessages = 0;

  @override
  void initState() {
    super.initState();
    _loadToken().then((_) {
      fetchDoctorDetails();
    });
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future<void> fetchDoctorDetails() async {
    final url = 'http://192.168.1.107:8000/api/doctor/${widget.doctorId}';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData is Map && responseData.containsKey('doctor')) {
        setState(() {
          doctor = responseData['doctor'];
          doctorMessages = responseData['doctor_messages'] ?? 0;
        });
      } else {
        setState(() {
          errorMessage = 'Unexpected response format';
        });
      }
    } else {
      setState(() {
        errorMessage = 'Failed to load doctor details: ${response.body}';
      });
    }
  }

  Future<void> requestDoctor() async {
    final response = await http.post(
      Uri.parse(
          'http://192.168.1.107:8000/api/doctor/requestdoctor/${widget.doctorId}'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
      setState(() {
        requested = true;
      });
    } else {
      throw Exception('Failed to send request');
    }
  }

  Future<void> deleteRequestDoctor() async {
    final response = await http.delete(
      Uri.parse(
          'http://192.168.1.107:8000/api/doctor/deleterequest/${widget.doctorId}'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
      setState(() {
        requested = false;
      });
    } else {
      throw Exception('Failed to delete request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: doctor.isEmpty && errorMessage.isEmpty
          ? Center(child: CircularProgressIndicator())
          : doctor.isEmpty
              ? Center(child: Text(errorMessage))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        color: Colors.blue,
                        width: double.infinity,
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 60.0,
                              backgroundImage: CachedNetworkImageProvider(
                                'http://192.168.1.107:8000${doctor['user']['picture']}',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              doctor['full_name'],
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              doctor['specialty'],
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.message, color: Colors.blue),
                                    Text(
                                      ' $doctorMessages',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Text('Messages'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.person, color: Colors.blue),
                                    Text(
                                      doctor['patients_number'].toString(),
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                    Text('Patients'),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 70),
                            Text(
                              'About Me:',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text(doctor['desc']),
                            SizedBox(height: 30),
                            Center(
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (requested) {
                                    await deleteRequestDoctor();
                                  } else {
                                    await requestDoctor();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      requested ? Colors.grey : Colors.blue,
                                  minimumSize: Size(double.infinity, 50),
                                ),
                                child: Text(
                                  requested
                                      ? 'Awaiting Approve'
                                      : 'Request Doctor',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
