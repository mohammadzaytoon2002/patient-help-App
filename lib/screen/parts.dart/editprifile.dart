import 'package:flutter/material.dart';
import 'package:watch3/componant/constant.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileEdite extends StatefulWidget {
  const ProfileEdite({Key? key}) : super(key: key);

  @override
  State<ProfileEdite> createState() => _ProfileEditeState();
}

class _ProfileEditeState extends State<ProfileEdite> {
  File? _image;
  Future<void> _getImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  String? _password;
  String? _confirmPassword;
  final _firstNameTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _passwordConfTextEditingController = TextEditingController();
  bool _obscureText = true;
  GlobalKey<FormState> passwConformKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwKey = GlobalKey<FormState>();
  GlobalKey<FormState> firstKey = GlobalKey<FormState>();
  GlobalKey<FormState> lastKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.blue,
          toolbarHeight: 150.0,
          elevation: 0,
          title: null,
          flexibleSpace: Transform.translate(
            offset: Offset(0.0, 35.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child: _image == null ? null : Container(),
                        radius: 50.0,
                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: _getImage,
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 241, 237, 237),
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
                    'profile',
                    style: TextStyle(
                      color: Styles.primaryColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    color: Styles.primaryColor,
                    thickness: 3,
                    indent: 25.0,
                    endIndent: 25.0,
                  ),
                ],
              ),
            ),
            Column(
              children: [
                SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Form(
                          key: firstKey,
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            controller: _firstNameTextEditingController,
                            maxLength: 20,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              hintText: 'Enter your first name',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Styles.c1,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
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
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "please enter your first name";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Form(
                          key: lastKey,
                          child: TextFormField(
                            keyboardType: TextInputType.name,
                            maxLength: 20,
                            controller: _lastNameTextEditingController,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              hintText: 'Enter your last name',
                              prefixIcon: Icon(
                                Icons.person,
                                color: Styles.c1,
                              ),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
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
                              filled: true,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15.0),
                Form(
                  key: passwKey,
                  child: TextFormField(
                    controller: _passwordTextEditingController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Styles.c1,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Styles.c1,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText =
                                !_obscureText; // تغيير حالة إظهار النص
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
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
                      filled: true,
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
                SizedBox(height: 15.0),
                Form(
                  key: passwConformKey,
                  child: TextFormField(
                    controller: _passwordConfTextEditingController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Styles.c1,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Styles.c1,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText =
                                !_obscureText; // تغيير حالة إظهار النص
                          });
                        },
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
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
                      filled: true,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _confirmPassword = value;
                      });
                    },
                    validator: (value) {
                      if (_password != _confirmPassword) {
                        return 'Password does not equal confirmation';
                      }
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
                SizedBox(height: 15.0),
                SizedBox(
                  width: size.width * 0.6,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (firstKey.currentState!.validate() &&
                          lastKey.currentState!.validate() &&
                          passwKey.currentState!.validate() &&
                          passwConformKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Success'),
                              content: Text(
                                  'All fields are valid. Ready to submit!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
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
                            content: Text('Please fill all required fields.'),
                            duration:
                                Duration(seconds: 2), // تحديد مدة ظهور الرسالة
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Styles.primaryColor),
                    ),
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
