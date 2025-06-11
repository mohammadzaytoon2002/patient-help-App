import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:watch3/screen/doctor_screen/allpatient.dart';
import 'package:watch3/screen/doctor_screen/faqdoctor.dart';
import 'package:watch3/screen/doctor_screen/homepage.dart';

import 'package:watch3/screen/profile/profiledoc.dart';

class BottomBardoc extends StatefulWidget {
  final int initialIndex;

  const BottomBardoc({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<BottomBardoc> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBardoc> {
  late int _selectedIndex;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePagedoctor(),
    PatientPage(),
    FAQScreen1(),
    MyProfile1doc(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onClick(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions[_selectedIndex]),
      backgroundColor: Color.fromARGB(255, 30, 71, 114),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Color.fromARGB(255, 30, 71, 114),
        buttonBackgroundColor: Color.fromARGB(255, 30, 71, 114),
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        index: _selectedIndex,
        onTap: _onClick,
        items: <Widget>[
          _buildNavigationBarItem('assets/images/home.png', 'Home'),
          _buildNavigationBarItem('assets/images/mypatient.png', 'my patients'),
          // _buildNavigationBarItem('assets/images/qr.png', 'Scan'),
          _buildNavigationBarItem('assets/images/faqicon.png', 'FAQ'),
          _buildNavigationBarItem('assets/images/user.png', 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavigationBarItem(String assetPath, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(
          assetPath,
          width: 28,
          height: 28,
          color: Colors.white,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class Constants {
  static const Color lightBlue = Color.fromARGB(255, 85, 162, 244);
}

class Styles1 {
  static const Color backgroundColor = Colors.white;
}
