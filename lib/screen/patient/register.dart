import 'package:watch3/componant/constant.dart';
import 'package:watch3/screen/parts.dart/already%20have%20account.dart';
import 'package:watch3/screen/patient/homepage2.dart';
import 'package:watch3/screen/patient/login%20.dart';
import 'package:watch3/screen/welcom/welcomscreen1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State {
  // Validator function for email field
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    // RegExp pattern for email validation
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null; // Return null if the input is valid
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var fullname;
    String? _firstName;
    String? _lastName;
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();
    String? _email;
    String? _password;
    String? _confirmPassword;
    TextEditingController _emailController = TextEditingController();
    bool _obscureText = true;
    _emailController.text = '';
    _passwordController.text = '';
    _confirmPasswordController.text = '';
    _passwordController.text = '';
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 241, 237, 237),
        appBar: AppBar(
          backgroundColor: Colors.blue, // لتغيير لون ال AppBar إلى اللون الأزرق
          toolbarHeight: 100,
          elevation: 0, // لإزالة الظل من ال AppBar
        ),
        body: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 50.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(
                                    context); // Go back when icon is pressed
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.blue, // Set icon color to blue
                              ),
                            ),
                            CircleAvatar(
                              backgroundImage: AssetImage(
                                  'assets/images/logo.png'), // تغيير المسار وفقًا لمسار الصورة الخاصة بك
                              radius: 50.0,
                            ),
                            SizedBox(width: 40.0), // Add space between fields
                          ],
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Register',
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
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: TextFormField(
                                controller: fullname,
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
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _firstName = value;
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: TextFormField(
                                controller: fullname,
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
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _lastName = value;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(
                            Icons.email,
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
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final RegExp emailRegex =
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _email = value;
                        },
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        controller: _passwordController,
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
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 9) {
                            return 'Password must be at least 9 characters';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _password = value;
                        },
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter your password',
                          prefixIcon: Icon(
                            Icons.lock,
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
                          if (value == null || value.isEmpty) {
                            return 'Please re-enter your password';
                          }
                          if (value != _password) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _confirmPassword = value;
                        },
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: size.width * 0.6,
                        height: 40.0,
                        child: ElevatedButton(
                          onPressed: () {
                            String email = _emailController.text;
                            String password = _passwordController.text;
                            String confirmPassword =
                                _confirmPasswordController.text;

                            if (email == 'mail@gmail.com' &&
                                password == '123456789' &&
                                password == confirmPassword) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage2()),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text('Invalid email or password.'),
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
          ],
        )));
  }
}
