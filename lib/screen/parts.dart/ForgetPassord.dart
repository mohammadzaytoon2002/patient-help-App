import 'package:flutter/material.dart';
import 'package:watch3/componant/constant.dart';
import 'package:watch3/controller/genral_controller.dart';
import 'package:watch3/screen/patient/register.dart';

class forgetPassowrd extends StatefulWidget {
  @override
  State<forgetPassowrd> createState() => _forgetPassowrdState();
}

class _forgetPassowrdState extends State<forgetPassowrd> {
  final _emaillTextEditingController = TextEditingController();

  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  bool _obscureTextPassword = true;
  ApiService forgetPassowrdd = ApiService();

  String? _email;

  GlobalKey<FormState> passwKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Styles.primaryColor,
          toolbarHeight: 150.0,
          elevation: 0,
          title:
              null, // Set title to null if you don't want to display any title
          flexibleSpace: Transform.translate(
            offset: Offset(0.0, 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/logo.jpg'),
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
                    'Forgot password ?',
                    style: TextStyle(
                      color: Styles.primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    cacheHeight: 240,
                    ('assets/forgetPassword.jpeg'),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Please Enter Your Email Address \n To Recieve a Verification Code',
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
                          borderRadius: BorderRadius.circular(30.0),
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
                  SizedBox(height: 50.0),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: size.width * 0.6,
                      height: 40.0, // Use fixed height value
                      child: ElevatedButton(
                        onPressed: () {
                          if (emailKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Success'),
                                  content: Text(
                                      'All fields are valid. Ready to submit!'),
                                  actions: [
                                    TextButton(
                                      onPressed: () async {
                                        _email =
                                            _emaillTextEditingController.text;
                                        await forgetPassowrdd
                                            .Emailforgot_passwordMethod(
                                                _email!, context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Please fill all required fields.'),
                                duration: Duration(
                                    seconds: 2), // تحديد مدة ظهور الرسالة
                              ),
                            );
                          }
                          // Handle login action
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Styles.primaryColor),
                        ),
                        child: Text(
                          'Send',
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
                                builder: (context) => SignUpForm()),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
