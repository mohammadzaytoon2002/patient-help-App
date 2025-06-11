import 'package:flutter/material.dart';
import 'package:watch3/componant/constant.dart';
import 'package:watch3/screen/parts.dart/navigatorbar.dart';
import 'package:watch3/screen/profile/profile.dart';

class UserManagementPagedoc extends StatelessWidget {
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
              "User Managment",
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
            UserManagementItem(
              title: "Manage Users",
              icon: Icons.person,
              onPress: () {
                // Handle onPress action here
              },
            ),
            Divider(),
            UserManagementItem(
              title: "Permissions",
              icon: Icons.security,
              onPress: () {
                // Handle onPress action here
              },
            ),
            Divider(),
            UserManagementItem(
              title: "Roles",
              icon: Icons.supervisor_account,
              onPress: () {
                // Handle onPress action here
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserManagementItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPress;

  const UserManagementItem({
    required this.title,
    required this.icon,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Styles.c1),
      title: Text(title, style: Styles.headerStyle2),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onPress,
    );
  }
}
