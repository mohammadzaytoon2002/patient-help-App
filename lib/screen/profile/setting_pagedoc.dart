import 'package:flutter/material.dart';
import 'package:watch3/componant/constant.dart';
import 'package:watch3/screen/parts.dart/navigatorbar.dart';
import 'package:watch3/screen/profile/profile.dart';

class SettingsPagedoc extends StatelessWidget {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyProfile1()),
                );
              },
            ),
            backgroundColor:
                Color.fromARGB(255, 30, 71, 114), // Your preferred color
            title: Text(
              "Setting",
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SettingItem(title: "Theme", icon: Icons.color_lens),
            Divider(),
            SettingItem(title: "Notifications", icon: Icons.notifications),
            Divider(),
            SettingItem(title: "Privacy", icon: Icons.lock),
            Divider(),
            SettingItem(title: "Language", icon: Icons.language),
            Divider(),
            SettingItem(title: "About", icon: Icons.info_outline),
          ],
        ),
      ),
    );
  }
}

class SettingItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const SettingItem({
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Styles.c1),
      title: Text(title, style: Styles.headerStyle2),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Handle onTap action here
      },
    );
  }
}
