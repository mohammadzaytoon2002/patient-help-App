import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:watch3/componant/constant.dart';
import 'package:watch3/controller/genral_controller.dart';
import 'package:watch3/screen/parts.dart/ForgetPassord.dart';
import 'package:watch3/screen/parts.dart/log%20in.dart';
import 'package:watch3/screen/parts.dart/rigester.dart';
import 'package:watch3/screen/patient/register.dart';

class LoginPagedoctor extends StatefulWidget {
  @override
  State<LoginPagedoctor> createState() => _LoginPagedoctorState();
}

class _LoginPagedoctorState extends State<LoginPagedoctor> {
  final _emaillTextEditingController = TextEditingController();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  bool _obscureTextPassword = true;
  ApiService loginn = ApiService();
  String? _email;
  String? _password;
  final _passwordTextEditingController = TextEditingController();
  GlobalKey<FormState> passwKey = GlobalKey<FormState>();
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMee();
    // Initialize Firebase Messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Got a foreground message: ${message.notification?.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.notification?.body ?? ""),
          duration: Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {},
          ),
        ),
      );
    });
  }

  // void _updateRememberMe(bool newValue) {
  //   setState(() {
  //     rememberMe = newValue;
  //   });
  // }

  void _loadRememberMee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      rememberMe = prefs.getBool('rememberMe') ?? false;
      if (rememberMe) {
        _emaillTextEditingController.text = prefs.getString('email') ?? 'k';
        _passwordTextEditingController.text =
            prefs.getString('password') ?? 'k';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 3, 88, 128),
          toolbarHeight: 150.0,
          elevation: 0,
          title: null,
          flexibleSpace: Transform.translate(
            offset: Offset(0.0, 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/logo.jpg'),
                  radius: 50.0,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  SizedBox(height: 40.0),
                  Text(
                    'Log In',
                    style: TextStyle(
                      color: Styles.primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    color: Styles.primaryColor,
                    thickness: 2.0,
                    indent: 50.0,
                    endIndent: 50.0,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Log in to your account',
                    style: TextStyle(
                      color: Styles.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: emailKey,
                    child: TextFormField(
                      controller: _emaillTextEditingController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icon(
                          Icons.email,
                          color: Styles.c1,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey[500]!,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Styles.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.white,
                        filled: false,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final RegExp emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Check your email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value;
                      },
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Form(
                    key: passwKey,
                    child: TextFormField(
                      controller: _passwordTextEditingController,
                      obscureText:
                          _obscureTextPassword, // Use separate state variable
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Styles.c1,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Styles.c1,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTextPassword = !_obscureTextPassword;
                            });
                          },
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: const Color.fromARGB(255, 104, 72, 72)!,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Styles.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.white,
                        filled: false,
                      ),
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => forgetPassowrd()),
                        );
                      },
                      child: Text(
                        'Forget your password?',
                        style: TextStyle(
                          color: Styles.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          setState(() {
                            rememberMe = value ?? false;
                            prefs.setBool('rememberMe', rememberMe);
                          });
                        },
                      ),
                      Text('Remember me'),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: size.width * 0.6,
                      height: 40.0, // Use fixed height value
                      child: ElevatedButton(
                        onPressed: () async {
                          if (emailKey.currentState!.validate() &&
                              passwKey.currentState!.validate()) {
                            _email = _emaillTextEditingController.text;
                            _password = _passwordTextEditingController.text;
                            await loginn.loginMethodDoctor(
                                _email!, _password!, context,
                                rememberMe: rememberMe);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Please fill all required fields.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromARGB(255, 3, 88, 128),
                          ),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Styles.primaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpForm1()),
                          );
                        },
                        child: Text(
                          'Create',
                          style: TextStyle(
                            color: Styles.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Are you a patient ? ",
                        style: TextStyle(
                          color: Styles.primaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  LoginPage(), // استبدل SignUpPage() بصفحة التسجيل الخاصة بك
                            ),
                          );
                        },
                        child: Text(
                          'Log in ',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 57, 89, 105),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Handle Facebook login action
                        },
                        icon: Icon(Icons.facebook),
                        color: Colors.blue,
                      ),
                      IconButton(
                        onPressed: () {
                          // Handle Google login action
                        },
                        icon: Icon(Icons.face),
                        color: Colors.red,
                      ),
                    ],
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
