import 'package:flutter/material.dart';
import 'package:watch3/componant/constant.dart';
import 'package:watch3/controller/genral_controller.dart';

class newpassord extends StatefulWidget {
  @override
  State<newpassord> createState() => _newpassordState();
}

class _newpassordState extends State<newpassord> {
  final _emaillTextEditingController = TextEditingController();

  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  ApiService newpassordd = ApiService();

  String? _password;
  String? _confirmPassword;
  GlobalKey<FormState> passwConformKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwKey = GlobalKey<FormState>();
  final _passwordTextEditingController = TextEditingController();
  final _passwordConfTextEditingController = TextEditingController();

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
                    'New password',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      'Your new password must be different\n    from previously used passwords',
                      style: TextStyle(
                        color: Styles.primaryColor,
                      ),
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
                      obscureText:
                          _obscureTextConfirmPassword, // Use separate state variable
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        hintText: 'Re-enter your password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Styles.c1,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Styles.c1,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureTextConfirmPassword =
                                  !_obscureTextConfirmPassword;
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
                        if (value == null || value.isEmpty) {
                          return 'Please re-enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        if (value != _password) {
                          return 'Password does not match the confirmation';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 40.0),
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: size.width * 0.6,
                      height: 40.0, // Use fixed height value
                      child: ElevatedButton(
                        onPressed: () async {
                          if (passwKey.currentState!.validate() &&
                              passwConformKey.currentState!.validate()) {
                            _password = _passwordTextEditingController.text;
                            _confirmPassword =
                                _passwordConfTextEditingController.text;
                            await newpassordd.restemail_pass_confirm(
                                _password!, _confirmPassword!, context);

                            // Additional actions when the button is pressed
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
                          backgroundColor:
                              MaterialStateProperty.all(Styles.primaryColor),
                        ),
                        child: Text(
                          'Create New Password',
                          style: TextStyle(color: Colors.white),
                        ),
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
