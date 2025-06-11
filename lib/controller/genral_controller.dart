import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/componant/bottombardoctor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:watch3/screen/models/medicin.dart';

import 'package:watch3/screen/parts.dart/log%20in.dart';
import 'package:watch3/screen/parts.dart/navigatorbar.dart';
import 'package:watch3/screen/parts.dart/newPassowrd.dart';
import 'package:watch3/screen/parts.dart/services.dart';
import 'package:watch3/screen/parts.dart/verify.dart';
import 'package:watch3/screen/parts.dart/verify_forget.dart';
import 'package:watch3/screen/patient/prediction/prediction_feed.dart';
import 'package:watch3/screen/report/report.dart';

enum UserType {
  Patient,
  Doctor,
}

class ApiService {
  // final String baseUrl;
  static var tokenlogin;
  static late String verfycode;
  static var tokenis;

  Future<void> register(
      String first_name,
      String last_name,
      String gender,
      String email,
      String password,
      String password_confirmation,
      BuildContext context) async {
    final url = Uri.parse('http://192.168.1.107:8000/api/users/register');

    final response = await http.post(url, body: {
      'first_name': first_name,
      'last_name': last_name,
      'gender': gender,
      'email': email,
      'password': password,
      'password_confirmation': password_confirmation,
    });

    if (response.statusCode == 200) {
      print("اهلا200");
      final responseData = json.decode(response.body);
      print(response.body);
      print(responseData["user"]["first_name"]);
      tokenis = responseData["user"]["verification_token"];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('All fields are valid. Ready to submit!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => verifyPage()));
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      print(tokenis);

      return tokenis;
    } else if (response.statusCode == 400) {
      print("400");
      final responseData = json.decode(response.body);
      print(response.body);
      final erorr = responseData["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$erorr",
            style: TextStyle(color: Colors.yellow),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      final message = 'An error occurred while decoding the response';
      print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(response.body);
      // Handle the error
      throw Exception(message);
    }
  }

  Future verify(String number1, BuildContext context) async {
    print(tokenis);

    final url =
        Uri.parse('http://192.168.1.107:8000/api/users/verfiyemail/$tokenis');

    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'ver_input': number1,
        }));
    print(response.statusCode);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final erorr = responseData["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$erorr",
            style: TextStyle(color: Colors.yellow),
          ),
          backgroundColor: Colors.blue,
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            maintainState: false,
            opaque: true,
            pageBuilder: (BuildContext context, _, __) => BottomBar(),
          ),
        );
      }
    } else {
      final responseData = json.decode(response.body);
      final erorr = responseData["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$erorr",
            style: TextStyle(color: Colors.yellow),
          ),
          backgroundColor: Colors.red,
        ),
      );
      final message = 'An error occurred while decoding the response';

      print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      // Handle the error
      print(message);
      print(response.body);
    }
    print(number1);
  }

  Future<void> loginMethod(String email, String password, BuildContext context,
      {bool rememberMe = false}) async {
    final url = Uri.parse('http://192.168.1.107:8000/api/users/login');
    print(email);
    print(password);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String tokenlogin = responseData["access_token"];
      int userId = responseData["user"]["id"];

      // حفظ التوكن و userId في SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', tokenlogin);
      await prefs.setInt('userId', userId);

      if (rememberMe) {
        await prefs.setBool('rememberMe', rememberMe);
        await prefs.setString('email', email);
        await prefs.setString('password', password);
        await prefs.setInt('role', UserType.Patient.index);

        List<String>? accounts = prefs.getStringList('accounts');
        if (accounts == null) {
          accounts = [];
        }
        if (!accounts.contains(email)) {
          accounts.add(email);
          await prefs.setStringList('accounts', accounts);
        }
      } else {
        await prefs.remove('rememberMe');
        await prefs.remove('email');
        await prefs.remove('password');
        await prefs.remove('userType');
      }

      await sendFCMTokenToServer(prefs);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBar()),
      );
    } else {
      handleLoginError(response, context);
    }
  }

  Future<void> loginMethodDoctor(
      String email, String password, BuildContext context,
      {bool rememberMe = false}) async {
    final url = Uri.parse('http://192.168.1.107:8000/api/users/login_doctor');
    print(email);
    print(password);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      String tokenlogin = responseData["access_token"];
      int userId = responseData["user"]["id"];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', tokenlogin);
      await prefs.setInt('userId', userId);
      await prefs.setInt('role', UserType.Doctor.index);

      if (rememberMe) {
        await prefs.setBool('rememberMe', rememberMe);
        await prefs.setString('email', email);
        await prefs.setString('password0', password);
      } else {
        await prefs.remove('rememberMe');
        await prefs.remove('emaill');
        await prefs.remove('passwordd');
      }

      await sendFCMTokenToServer(prefs);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomBardoc()),
      );
    } else {
      handleLoginError(response, context);
    }
  }

  Future<void> sendFCMTokenToServer(SharedPreferences prefs) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCM Token: $fcmToken");

    if (fcmToken != null) {
      String? storedToken = prefs.getString('token');

      if (storedToken != null) {
        final fcmUrl =
            Uri.parse('http://192.168.1.107:8000/api/users/fcm-token');
        final fcmResponse = await http.post(fcmUrl,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $storedToken',
            },
            body: json.encode({
              'fcm_token': fcmToken,
            }));

        if (fcmResponse.statusCode == 200) {
          print("FCM token successfully sent to the server");
        } else {
          print("Failed to send FCM token to the server");
        }
      }
    }
  }

  void handleLoginError(http.Response response, BuildContext context) {
    final responseData = json.decode(response.body);
    final error = responseData["message"];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$error",
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.red,
      ),
    );
    final message = 'An error occurred while decoding the response';
    print(message);
  }

  Future Emailforgot_passwordMethod(String email, context) async {
    final url =
        Uri.parse('http://192.168.1.107:8000/api/users/forgot_password');

    final response = await http.post(url, body: {
      'email': email,
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      //print(response.body);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => verify_forgetPass()),
        );
        final erorr = responseData["message"];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "$erorr",
              style: TextStyle(color: Colors.yellow),
            ),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } else {
      final message = 'An error occurred while decoding the response';
      print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      print(response.body);
      // Handle the error
      throw Exception(message);
    }
  }

  Future restemail_pass_verifyMethod(String number, context) async {
    final url =
        Uri.parse('http://192.168.1.107:8000/api/users/code_password_check');
    verfycode = number;
    final response = await http.post(url, body: {
      'code': number,
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(response.body);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => newpassord()),
      );
      final erorr = responseData["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$erorr",
            style: TextStyle(color: Colors.yellow),
          ),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      final message = 'An error occurred while decoding the response';
      print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      // Handle the error
      throw Exception(message);
    }
  }

  Future restemail_pass_confirm(
      String password, String passwordconfirm, context) async {
    final url = Uri.parse(
        'http://192.168.1.107:8000/api/users/reset_password/$verfycode');

    final response = await http.post(url, body: {
      'password': password,
      'password_confirmation': passwordconfirm,
    });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(response.body);
      final erorr = responseData["message"];
      print(erorr);

      if (response.statusCode == 200) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('تم تغيير كلمة سر بنجاح'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      final message = 'An error occurred while decoding the response';
      print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      // Handle the error
      throw Exception(message);
    }
  }

  Future restemail_Get_verifyMethod(context) async {
    final url = 'http://192.168.1.107:8000/api/users/resend/$tokenis';
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $tokenis'},
    );
    // final response = await http.get(url, body: {

    // });

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        final erorr = responseData["message"];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "$erorr",
              style: TextStyle(color: Colors.yellow),
            ),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } else {
      final responseData = json.decode(response.body);
      final erorr = responseData["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$erorr",
            style: TextStyle(color: Colors.yellow),
          ),
          backgroundColor: Colors.red,
        ),
      );
      final message = 'An error occurred while decoding the response';
      print("errrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      // Handle the error
      throw Exception(message);
    }
  }

  Future<void> medicenMethod(
      String _medicationType,
      String _selectedTime,
      String _medicineName,
      int _quantity,
      String selectedValue,
      String _frequency,
      String _selectedDaysWeekString,
      String _selectedDaysMounthString,
      String _startDate,
      String _endDate,
      String note,
      context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenis = prefs.getString('token');
    var url = Uri.parse('http://192.168.1.107:8000/api/medication/');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenis', // تمرير التوكن في الرأس
      },
      body: json.encode({
        'type': _medicationType,
        'time': _selectedTime,
        'name': _medicineName,
        'pill': _quantity,
        'unit': selectedValue,
        'freq': _frequency,
        'specific_day_week': _selectedDaysWeekString,
        'specific_day_month': _selectedDaysMounthString,
        'time_range_start': _startDate,
        'time_range_end': _endDate,
        'note': note,
      }),
    );
    print('ssssssssssssssss');
    print(_startDate);
    print(_endDate);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      print('تم إرسال البيانات بنجاح.');

      final erorr = responseData["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$erorr",
            style: TextStyle(color: Colors.yellow),
          ),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      final responseData = json.decode(response.body);
      final erorr = responseData["message"];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "$erorr",
            style: TextStyle(color: Colors.yellow),
          ),
          backgroundColor: Colors.red,
        ),
      );
      print('فشل إرسال البيانات. الرد: ${response.statusCode}');
      print('الرد النصي: ${response.body}');
      try {
        final responseData = json.decode(response.body);
        final error = responseData["message"];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "$erorr",
              style: TextStyle(color: Colors.yellow),
            ),
            backgroundColor: Colors.red,
          ),
        );
        print(error);
      } catch (e) {
        print('خطأ في فك ترميز الاستجابة: $e');
      }
    }
  }

  Future showMedications() async {
    var url = Uri.parse('http://192.168.1.107:8000/api/medication/');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenis = prefs.getString('token');

    var response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenis',
      },
    );

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      //  print(jsonData); // Print data for verificatio
      return (jsonData['medications'] as List)
          .map((data) => Medication.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load medications');
    }
  }

  Future DeletMedications(int id) async {
    var url =
        Uri.parse('http://192.168.1.107:8000/api/medication/delete_med/$id');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tokenis = prefs.getString('token');
    var response = await http.delete(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $tokenis',
      },
    );

    if (response.statusCode == 200) {
      print('Medication deleted successfully');
    } else {
      print(response.body);
      throw Exception('Failed to delete medication');
    }
  }
}
