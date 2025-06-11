import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/pusher/chat_pusher.dart';

class MyDoctor extends StatefulWidget {
  final int doctorId;

  MyDoctor({required this.doctorId});

  @override
  _MyDoctorState createState() => _MyDoctorState();
}

class _MyDoctorState extends State<MyDoctor> {
  Map doctor = {};
  bool requested = false;
  String? token;
  String errorMessage = '';
  int doctorMessages = 0;
  int? patientId;

  @override
  void initState() {
    super.initState();
    _loadToken().then((_) {
      fetchPatientIdAndDetails();
      fetchChatIdIfAvailable();
    });
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future<void> fetchPatientIdAndDetails() async {
    patientId = await fetchPatientId();
    if (patientId != null) {
      await fetchDoctorDetails();
    } else {
      setState(() {
        errorMessage = 'Failed to fetch patient details';
      });
    }
  }

  Future<int?> fetchPatientId() async {
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
              (participant) => participant['user']['id'] == widget.doctorId,
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

  Future<void> deleteDoctor() async {
    final response = await http.delete(
      Uri.parse(
          'http://192.168.1.107:8000/api/doctor/deletedoctor/${widget.doctorId}'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Doctor has been deleted')));
      await Future.delayed(Duration(seconds: 5));
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to delete doctor')));
    }
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete the doctor?'),
          content: Text('Are you sure you want to delete this doctor?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await deleteDoctor();
              },
              child: Text('Yes', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      },
    );
  }

  // Future<void> fetchChatIdAndNavigate() async {
  //   if (patientId == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Patient ID not found'),
  //       ),
  //     );
  //     return;
  //   }

  //   final url = 'http://192.168.1.107:8000/api/chat';
  //   final response = await http.get(
  //     Uri.parse(url),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     final responseData = json.decode(response.body);
  //     if (responseData is Map && responseData.containsKey('chats')) {
  //       List chats = responseData['chats'];
  //       if (chats.isNotEmpty) {
  //         final chat = chats.firstWhere(
  //           (chat) => chat['participants'].any(
  //             (participant) => participant['user']['id'] == widget.doctorId,
  //           ),
  //           orElse: () => null,
  //         );
  //         if (chat != null) {
  //           final chatId = chat['id'].toString();
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => ChatPage(
  //                 chatId: chatId,
  //                 userId: patientId!,
  //                 token: token!,
  //               ),
  //             ),
  //           );
  //         } else {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             SnackBar(
  //               content: Text('No chat found with the specified doctor'),
  //             ),
  //           );
  //         }
  //       } else {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text('No chats available'),
  //           ),
  //         );
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Unexpected response format'),
  //         ),
  //       );
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Failed to load chat id: ${response.body}'),
  //       ),
  //     );
  //   }
  // }
  Future<void> fetchChatIdAndNavigate() async {
    if (patientId == null) {
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
              (participant) => participant['user']['id'] == widget.doctorId,
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
                  userId: patientId!,
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
                            GestureDetector(
                              onTap: () {
                                if (doctor['user'] != null &&
                                    doctor['user']['picture'] != null) {
                                  _showImageDialog(
                                      'http://192.168.1.107:8000${doctor['user']['picture']}');
                                }
                              },
                              child: CircleAvatar(
                                radius: 60.0,
                                backgroundImage: doctor['user'] != null &&
                                        doctor['user']['picture'] != null
                                    ? CachedNetworkImageProvider(
                                        'http://192.168.1.107:8000${doctor['user']['picture']}')
                                    : AssetImage('assets/images/default.png')
                                        as ImageProvider,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              doctor['full_name'] ?? 'No name',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              doctor['specialty'] ?? 'No specialty',
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
                                      doctor['patients_number']?.toString() ??
                                          '0',
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
                            Text(doctor['desc'] ?? 'No description available'),
                            SizedBox(height: 30),
                            Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      _showDeleteConfirmationDialog();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      minimumSize: Size(150, 50),
                                    ),
                                    child:
                                        Icon(Icons.close, color: Colors.white),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      fetchChatIdAndNavigate();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      minimumSize: Size(150, 50),
                                    ),
                                    child: Text('Message',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ],
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
