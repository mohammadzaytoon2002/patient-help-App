// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:shared_preferences/shared_preferences.dart';

// class DoctorProvider with ChangeNotifier {
//   List _doctors = [];
//   String? _token;

//   List get doctors => _doctors;

//   DoctorProvider() {
//     _loadToken().then((_) {
//       fetchDoctors();
//     });
//   }

//   Future<void> _loadToken() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _token = prefs.getString('token');
//     notifyListeners();
//   }

//   Future<void> fetchDoctors() async {
//     final response = await http.get(
//       Uri.parse('http://192.168.1.107:8000/api/doctor/mydoctors/showdoctors'),
//       headers: {'Authorization': 'Bearer $_token'},
//     );
//     if (response.statusCode == 200) {
//       final responseData = json.decode(response.body);
//       if (responseData['doctors'] is List) {
//         _doctors = responseData['doctors'];
//       } else {
//         _doctors = [];
//         print('Unexpected response format');
//       }
//       notifyListeners();
//     } else {
//       throw Exception('Failed to load doctors');
//     }
//   }
// }
