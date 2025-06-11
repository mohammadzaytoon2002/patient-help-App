import 'package:flutter/material.dart';
import 'package:watch3/componant/constant.dart';
import 'package:watch3/controller/genral_controller.dart';
import 'package:watch3/screen/parts.dart/log%20in.dart';
import 'package:watch3/screen/patient/login%20.dart';

class SignUpForm1 extends StatefulWidget {
  const SignUpForm1({
    Key? key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State {
  ApiService registerr = ApiService();
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  String? _groupValue; // متغير لتخزين قيمة المجمو
  bool _isSelected = false;
  String? gender;

  String? password;
  final _emaillTextEditingController = TextEditingController();
  var email = '';
  final _firstNameTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _passwordConfTextEditingController = TextEditingController();
  GlobalKey<FormState> passwConformKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwKey = GlobalKey<FormState>();
  GlobalKey<FormState> firstKey = GlobalKey<FormState>();
  GlobalKey<FormState> lastKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> genderKey = GlobalKey<FormState>();

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

    String? _firstName;

    String? _lastName;
    String? _email;
    String? _confirmPassword;

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
                    backgroundImage: AssetImage('assets/images/logo.jpg'),
                    radius: 50.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        backgroundColor:
            Color.fromARGB(255, 241, 237, 237), // Set background color to gray
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      filled: true,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Select Gender:',
                      style: TextStyle(fontSize: 16),
                    ),
                    Radio(
                      value: 'male',
                      groupValue: _groupValue,
                      onChanged: (value) {
                        setState(() {
                          _isSelected = false;

                          _groupValue = value
                              .toString(); // تحديث قيمة المجموعة لتكون String
                        });
                      },
                    ),
                    Text('Male'),
                    Radio(
                      value: 'female',
                      groupValue: _groupValue,
                      onChanged: (value) {
                        setState(() {
                          _isSelected = false;
                          _groupValue = value
                              .toString(); // تحديث قيمة المجموعة لتكون String
                        });
                      },
                    ),
                    Text('Female'),
                  ],
                ),
                Visibility(
                  visible: _isSelected,
                  child: Text(
                    'Please select an gender',
                    style: TextStyle(color: Colors.red),
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
                        password = value;
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
                      if (value != password) {
                        return 'Password does not match the confirmation';
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
                    onPressed: () async {
                      if (_groupValue == null) {
                        setState(() {
                          _isSelected = true;
                        });
                      }

                      if (firstKey.currentState!.validate() &&
                          lastKey.currentState!.validate() &&
                          emailKey.currentState!.validate() &&
                          passwKey.currentState!.validate() &&
                          passwConformKey.currentState!.validate()) {
                        _firstName = _firstNameTextEditingController.text;
                        _lastName = _lastNameTextEditingController.text;
                        _email = _emaillTextEditingController.text;
                        password = _passwordTextEditingController.text;
                        _confirmPassword =
                            _passwordConfTextEditingController.text;

                        await registerr.register(
                          _firstName!,
                          _lastName!,
                          _groupValue ?? '', // Ensure _groupValue is not null
                          _email!,
                          password!,
                          _confirmPassword!,
                          context,
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill all required fields.'),
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
                      'SIGN UP',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Do you have a account? ",
                      style: TextStyle(
                        color: Styles.primaryColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: Text(
                        'login',
                        style: TextStyle(
                          color: Styles.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        )));
  }
}

GlobalKey<FormState> genderKey = GlobalKey<FormState>();

class GenderSelectionWidget extends StatefulWidget {
  @override
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;

// String? validateGender(String? value) {
//   if (!_isMaleSelected && !_isFemaleSelected) {
//     return 'Please select your gender';
//   }
//   return null;
// }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Select Gender:',
          style: TextStyle(fontSize: 16),
        ),
        Form(
          key: genderKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _isMaleSelected = true;
                    _isFemaleSelected = false;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'male',
                        groupValue: _isMaleSelected ? 'male' : null,
                        onChanged: (value) {
                          setState(() {
                            _isMaleSelected = true;
                            _isFemaleSelected = false;
                          });
                        },
                      ),
                      Text('Male'),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              InkWell(
                onTap: () {
                  setState(() {
                    _isMaleSelected = false;
                    _isFemaleSelected = true;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'female',
                        groupValue: _isFemaleSelected ? 'female' : null,
                        onChanged: (value) {
                          setState(() {
                            _isMaleSelected = false;
                            _isFemaleSelected = true;
                          });
                        },
                      ),
                      Text('Female'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
