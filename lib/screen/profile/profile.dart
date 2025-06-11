import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:watch3/componant/constant.dart';
import 'package:watch3/screen/models/profilemenu.dart';
import 'package:watch3/screen/profile/about_us.dart';
import 'package:watch3/screen/profile/profileEdit.dart';
import 'package:watch3/screen/profile/setting_page.dart';
import 'package:watch3/screen/profile/usermangments.dart';
import 'package:watch3/screen/parts.dart/log%20in.dart';
import 'package:watch3/screen/parts.dart/navigatorbar.dart';

class MyProfile1 extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile1> {
  String fullname = "";
  String email = "";
  String? token;
  String? userPicture;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void _logOut(BuildContext context) async {
    await _performLogout(); // Perform logout API call
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (route) => false,
    );
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    if (token != null && token!.isNotEmpty) {
      await fetchUserInfo();
    } else {
      // Handle the case where the user is not logged in
      print('User is not logged in or token is null');
    }
  }

  Future<void> fetchUserInfo() async {
    final response = await http.get(
      Uri.parse('http://192.168.1.107:8000/api/users/me'),
      headers: <String, String>{
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['user'];
      final firstName = user['first_name'];
      final lastName = user['last_name'];
      final fullName = '$firstName $lastName';
      final email = user['email'];
      final picture = user['picture'];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('fullname', fullName);
      await prefs.setString('email', email);

      setState(() {
        this.fullname = fullName;
        this.email = email;
        this.userPicture = picture; // Save user picture URL
      });
    } else {
      throw Exception('Failed to load user info');
    }
  }

  void _showProfilePicture(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                userPicture != null
                    ? Image.network(
                        'http://192.168.1.107:8000$userPicture',
                        fit: BoxFit.cover,
                      )
                    : Image.asset("assets/images/logo.png", fit: BoxFit.cover),
                // SizedBox(height: 10),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: Text("Close"),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100.0),
                child: ClipPath(
                  clipper: AppBarClipper(),
                  child: AppBar(
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    backgroundColor: Constants.lightBlue,
                    title: Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    centerTitle: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () => _showProfilePicture(context),
                            child: SizedBox(
                              width: 120,
                              height: 120,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: userPicture != null
                                    ? Image.network(
                                        'http://192.168.1.107:8000$userPicture',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset("assets/images/logo.png",
                                        fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProfileEdite1(),
                                  ),
                                );
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Styles.c1,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Styles.c12,
                                  size: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          Text(fullname, style: Styles.headerStyle2),
                          SizedBox(height: 5),
                          Text(email, style: Styles.headerStyle3),
                        ],
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfileEdite1(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue, // خلفية الزر بلون أزرق
                          ),
                          child: Text(
                            "Edit Profile",
                            style:
                                TextStyle(color: Colors.white), // لون النص أبيض
                          ),
                        ),
                      ),

                      SizedBox(height: 30),
                      Divider(),
                      SizedBox(height: 20),
                      ProfileMenu(
                        title: "Settings",
                        icon: Icons.settings,
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()),
                          );
                        },
                      ),
                      ProfileMenu(
                        title: "User Management",
                        icon: Icons.check,
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserManagementPage()),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Colors.grey.withOpacity(0.1),
                      ),
                      //   SizedBox(height: 20),
                      ProfileMenu(
                        title: "About Us",
                        icon: Icons.info_outline,
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AboutUsPage()),
                          );
                        },
                      ),
                      SizedBox(height: 60),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            _logOut(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue, // تغيير لون الزر إلى الأزرق
                          ),
                          child: Text(
                            "Log out",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _performLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      print('Token not found in shared preferences.');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://192.168.1.107:8000/api/users/logout'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        print('Logged out successfully');
      } else {
        print('Failed to logout with status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error logging out: $e');
    }

    await prefs.clear(); // Clear all shared preferences on logout
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
