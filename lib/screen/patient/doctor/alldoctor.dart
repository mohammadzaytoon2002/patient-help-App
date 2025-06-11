import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/screen/patient/doctor/doctor_details.dart';

class DoctorsPage extends StatefulWidget {
  @override
  _DoctorsPageState createState() => _DoctorsPageState();
}

class _DoctorsPageState extends State<DoctorsPage> {
  List doctors = [];
  TextEditingController searchController = TextEditingController();
  String? token;
  String query = "";

  @override
  void initState() {
    super.initState();
    _loadToken().then((_) {
      fetchAllDoctors();
    });
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future<void> fetchAllDoctors() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/doctor'),
      headers: {'Authorization': 'Bearer $token'},
    );
    //  print('Response body: ${response.body}');
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData is List) {
        setState(() {
          doctors = responseData;
        });
      } else if (responseData is Map) {
        setState(() {
          doctors = responseData['doctor'] ?? [];
        });
      } else {
        setState(() {
          doctors = [];
        });
        print('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Future<void> searchDoctors(String query) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.107:8000/api/doctor/search'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({'query': query}),
    );
    if (response.statusCode == 200) {
      setState(() {
        doctors = json.decode(response.body)['doctors'];
      });
    } else {
      throw Exception('Failed to search doctor');
    }
  }

  Future<void> requestDoctor(int doctorId) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.107:8000/api/doctor/requestdoctor/$doctorId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to send request')));
    }
  }

  Future<void> deleteRequestDoctor(int doctorId) async {
    final response = await http.delete(
      Uri.parse('http://192.168.1.107:8000/api/doctor/deleterequest/$doctorId'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['message'])));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete request')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text('All Doctors', style: TextStyle(color: Colors.white))),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
            // Implement your own back navigation
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      query = value;
                    });
                    searchDoctors(value);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search Help',
                    labelText: 'Search',
                    contentPadding: EdgeInsets.all(16.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doctor = doctors[index];
                  return DoctorCard(
                    doctor: doctor,
                    onRequest: () async {
                      await requestDoctor(doctor['user_id']);
                      setState(() {
                        // Assuming you have a mechanism to update the UI after request
                      });
                    },
                    onDeleteRequest: () async {
                      await deleteRequestDoctor(doctor['user_id']);
                      setState(() {
                        // Assuming you have a mechanism to update the UI after request
                      });
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorDetailPage(
                            doctorId: doctor['user_id'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DoctorCard extends StatefulWidget {
  final Map doctor;
  final Future<void> Function() onRequest;
  final Future<void> Function() onDeleteRequest;
  final VoidCallback onTap;

  DoctorCard({
    required this.doctor,
    required this.onRequest,
    required this.onDeleteRequest,
    required this.onTap,
  });

  @override
  _DoctorCardState createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  bool requested = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35.0,
                backgroundImage: CachedNetworkImageProvider(
                  'http://192.168.1.107:8000${widget.doctor['user']['picture']}',
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor['full_name'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      widget.doctor['specialty'],
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (requested) {
                              await widget.onDeleteRequest();
                              setState(() {
                                requested = false;
                              });
                            } else {
                              await widget.onRequest();
                              setState(() {
                                requested = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                requested ? Colors.grey : Colors.blue,
                            minimumSize: Size(150, 40),
                          ),
                          child: Text(
                            requested ? 'Awaiting Approve' : 'Request Doctor',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.person),
                            SizedBox(width: 4.0),
                            Text(widget.doctor['patients_number'].toString()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
