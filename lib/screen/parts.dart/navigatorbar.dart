import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:watch3/componant/constant.dart';
import 'package:watch3/screen/profile/profile.dart';
import 'package:watch3/screen/parts.dart/services.dart';
import 'package:watch3/screen/patient/homepage2.dart';
import 'package:watch3/screen/patient/prediction/prediction.dart';
import 'package:watch3/screen/patient/scanproduct.dart';

class BottomBar extends StatefulWidget {
  final int initialIndex;

  const BottomBar({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  late int _selectedIndex;

  static final List<Widget> _widgetOptions = <Widget>[
    HomePage2(),
    PredictionPage(),
    Scan_Prod(),
    ServicePage(),
    MyProfile1(),
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
      backgroundColor: const Color.fromARGB(255, 71, 167, 246),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        animationCurve: Curves.easeInOut,
        index: _selectedIndex,
        onTap: _onClick,
        items: <Widget>[
          _buildNavigationBarItem('assets/images/home.png', 'Home'),
          _buildNavigationBarItem(
              'assets/images/predictive-chart.png', 'Prediction'),
          _buildNavigationBarItem('assets/images/qr.png', 'Scan'),
          _buildNavigationBarItem(
              'assets/images/customer-service.png', 'Services'),
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
