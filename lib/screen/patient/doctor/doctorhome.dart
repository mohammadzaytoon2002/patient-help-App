import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/screen/patient/doctor/mydoctor.dart';

class DoctorsHome extends StatefulWidget {
  @override
  _DoctorsHomeState createState() => _DoctorsHomeState();
}

class _DoctorsHomeState extends State<DoctorsHome> {
  List doctors = [];
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken().then((_) {
      fetchDoctors();
    });
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future<void> fetchDoctors() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/doctor/mydoctors/showdoctors'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData['doctors'] is List) {
        setState(() {
          doctors = responseData['doctors'];
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

  @override
  Widget build(BuildContext context) {
    return doctors.isEmpty
        ? CircularProgressIndicator()
        : Container(
            height: 150.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                final doctor = doctors[index];
                return DoctorCard(doctor: doctor);
              },
            ),
          );
  }
}

class DoctorCard extends StatelessWidget {
  final Map doctor;

  DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    final pictureUrl =
        doctor['user'] != null && doctor['user']['picture'] != null
            ? 'http://192.168.1.107:8000${doctor['user']['picture']}'
            : 'http://192.168.1.107:8000/images/default.png';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MyDoctor(doctorId: doctor['user_id']),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 4.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: Container(
          width: 350.0,
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4FC3F7), // Light Blue
                Color.fromARGB(255, 142, 199, 243), // Dark Blue
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: Container(
                  width: 120.0,
                  height: 120.0,
                  child: CachedNetworkImage(
                    imageUrl: pictureUrl,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      doctor['full_name'] ?? 'No name',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      doctor['specialty'] ?? 'No specialty',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Row(
                      children: [
                        Icon(Icons.person, size: 16.0, color: Colors.white70),
                        SizedBox(width: 4.0),
                        Text(
                          '${doctor['patients_number'] ?? 0} patients',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.white70,
                          ),
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
