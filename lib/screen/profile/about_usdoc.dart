import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watch3/componant/constant.dart';
import 'package:watch3/screen/parts.dart/navigatorbar.dart';
import 'package:watch3/screen/profile/profile.dart';
import 'package:watch3/screen/parts.dart/googlesignin.dart';

class AboutUsPagedoc extends StatelessWidget {
  final String phoneNumber = "+123456789";
  final String emailAddress = "info@example.com";
  final GoogleSignInProvider _googleSignInProvider =
      GoogleSignInProvider(); // إنشاء مثيل للمقدم

  @override
  Widget build(BuildContext context) {
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
            backgroundColor: Color.fromARGB(255, 30, 71, 114),
            title: Text(
              "About Us",
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
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: Image.asset("assets/images/logo.png"),
            ),
            SizedBox(height: 20.0),
            Text(
              "Welcome to Diabetes Gene Finder and Predictor App",
              textAlign: TextAlign.center,
              style: Styles.headerStyle2,
            ),
            SizedBox(height: 20.0),
            Text(
              "Our application provides comprehensive tools for managing diabetes, featuring:",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ListTile(
              leading: Icon(Icons.check, color: Styles.c1),
              title: Text(
                "Track health metrics like blood sugar, heartbeat, and oxygenation via smartwatch or manual entry.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check, color: Styles.c1),
              title: Text(
                "Receive reminders for medication schedules and doctor appointments.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check, color: Styles.c1),
              title: Text(
                "Predict genetic susceptibility to diabetes and related complications.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check, color: Styles.c1),
              title: Text(
                "Scan products via QR codes to check their sugar content suitability.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check, color: Styles.c1),
              title: Text(
                "Generate reports and monitor your health over time.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            ListTile(
              leading: Icon(Icons.check, color: Styles.c1),
              title: Text(
                "Connect with your healthcare provider for personalized advice and support.",
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 30.0),
            Text(
              "Our goal is to provide you with the tools you need to effectively manage your diabetes and improve your quality of life.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _launchPhone(phoneNumber);
                  },
                  child: ContactIconButton(
                    icon: Icons.phone,
                    label: phoneNumber,
                  ),
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    _handleGoogleLogin(context);
                  },
                  child: ContactIconButton(
                    icon: Icons.email,
                    label: emailAddress,
                  ),
                ),
                //SizedBox(width: 30.0),
                // GestureDetector(
                //   onTap: () {
                //     _handleGoogleLogin(context);
                //   },
                //   child: ContactIconButton(
                //     icon: Icons.message,
                //     label: "geo123@gmail.sy",
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _launchPhone(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // void _launchEmail(String emailAddress) async {
  //   String url = 'mailto:$emailAddress';
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  void _handleGoogleLogin(BuildContext context) async {
    try {
      await _googleSignInProvider.googleLogin();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to log in: $e")),
      );
    }
  }
}

class ContactIconButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const ContactIconButton({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30.0,
          backgroundColor: Constants.lightBlue.withOpacity(0.5),
          child: IconButton(
            icon: Icon(icon, color: Constants.lightBlue, size: 32.0),
            onPressed: () {},
          ),
        ),
        SizedBox(height: 10.0),
        Text(
          label,
          style: TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
