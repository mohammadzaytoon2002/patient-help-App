import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/componant/constant.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:watch3/screen/parts.dart/navigatorbar.dart';

class ProfileEdite1 extends StatefulWidget {
  const ProfileEdite1({Key? key}) : super(key: key);

  @override
  State<ProfileEdite1> createState() => _ProfileEditeState();
}

class _ProfileEditeState extends State<ProfileEdite1> {
  File? _image;
  String? _image2;
  String? _password;
  String? _confirmPassword;
  String? age;
  String? desc;

  final _firstNameTextEditingController = TextEditingController();
  final _lastNameTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _passwordConfTextEditingController = TextEditingController();
  final _ageTextEditingController = TextEditingController();
  final _descTextEditingController = TextEditingController();

  bool _obscureText = true;
  GlobalKey<FormState> passwConformKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwKey = GlobalKey<FormState>();
  GlobalKey<FormState> firstKey = GlobalKey<FormState>();
  GlobalKey<FormState> lastKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> ageKey = GlobalKey<FormState>();
  GlobalKey<FormState> descKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String apiUrl = 'http://192.168.1.107:8000/api/users/me';

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final Map<String, dynamic> user = responseData['user'];

      _firstNameTextEditingController.text = user['first_name'];
      _lastNameTextEditingController.text = user['last_name'];
      _ageTextEditingController.text = user['patient']['age'].toString();
      _descTextEditingController.text = user['patient']['desc'];

      String imageUrl = 'http://192.168.1.107:8000${user['picture']}';
      setState(() {
        _image2 = imageUrl;
        print(imageUrl);
      });

      setState(() {});
    } else {
      print('Failed to fetch user data');
    }
  }

  Future<void> _updateProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String apiUrl = 'http://192.168.1.107:8000/api/users/editprofile';

    Map<String, dynamic> requestBody = {
      'first_name': _firstNameTextEditingController.text,
      'last_name': _lastNameTextEditingController.text,
      'age': _ageTextEditingController.text,
      'desc': _descTextEditingController.text,
    };

    if (_password != null && _password!.isNotEmpty) {
      requestBody['password'] = _password;
      requestBody['password_confirmation'] = _confirmPassword;
    }

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Profile updated successfully');
    } else {
      print('Failed to update profile');
    }
  }

  Future<void> _updateProfilePicture() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String apiUrl = 'http://192.168.1.107:8000/api/users/changepicture';

    if (!kIsWeb) {
      if (Platform.isAndroid) {
        apiUrl = 'http://192.168.1.107:8000/api/users/changepicture';
      }
    }

    if (_image == null) {
      print('No image selected.');
      return;
    }

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(apiUrl),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.files
        .add(await http.MultipartFile.fromPath('picture', _image!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Profile picture updated successfully');
    } else {
      print('Failed to update profile picture');
    }
  }

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
                        radius: 50.0,
                        backgroundImage:
                            _image != null ? FileImage(_image!) : null,
                        child: _image == null && _image2 != null
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        _image2!), // Load image from network
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return Wrap(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text('Camera'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _getImage(ImageSource.camera);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.photo_library),
                                      title: Text('Gallery'),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _getImage(ImageSource.gallery);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
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
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.blue.shade900, Colors.blue.shade300],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ).createShader(bounds),
                    child: Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.blue.shade900,
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
                  ),
                ),
                SizedBox(height: 15.0),
                Form(
                  key: ageKey,
                  child: TextFormField(
                    controller: _ageTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'age',
                      hintText: 'enter your age',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Styles.c1,
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
                        age = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 15.0),
                Form(
                  key: descKey,
                  child: TextFormField(
                    controller: _descTextEditingController,
                    decoration: InputDecoration(
                      labelText: 'desc',
                      hintText: 'enter your description',
                      prefixIcon: Icon(
                        Icons.person,
                        color: Styles.c1,
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
                        desc = value;
                      });
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
                        _updateProfile();
                        if (_image != null) {
                          _updateProfilePicture();
                        }
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Success'),
                              content: Text(
                                  'All fields are valid. Profile updated successfully!'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BottomBar(
                                                initialIndex: 4,
                                              )),
                                    );
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
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                    ),
                    child: Text(
                      'SAVE',
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
