import 'package:flutter/material.dart';
import 'package:watch3/componant/shape.dart';
import 'package:watch3/screen/parts.dart/navigatorbar.dart';
import 'package:watch3/screen/parts.dart/watchpage.dart';
import 'package:watch3/screen/patient/doctor/alldoctor.dart';
import 'package:watch3/screen/patient/faq.dart';
import 'package:watch3/screen/patient/homepage2.dart';
import 'package:watch3/screen/patient/medicine/SHOWMEDI.dart';
import 'package:watch3/screen/patient/medicine/seeall.dart';
import 'package:watch3/screen/patient/prediction/pred_result.dart';
import 'package:watch3/screen/report/allreport.dart';
import 'package:watch3/screen/report/report.dart';

class ServicePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0),
        child: AppBar(
          backgroundColor: Colors.blue,
          shape: CustomShapeBorder(),
          toolbarHeight: 150.0,
          elevation: 0,
          leading: IconButton(
            color: Colors.white,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomBar()),
              );
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our Services',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
              SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 35, 61, 209).withOpacity(0.3),
                ),
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AnimatedServiceItem(
                index: 0,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WatchScreen()),
                  );
                }),
            AnimatedServiceItem(
                index: 1,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowMedication()),
                  );
                }),
            AnimatedServiceItem(
                index: 2,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GeneratingReportPage()),
                  );
                }),
            AnimatedServiceItem(
                index: 3,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DoctorsPage()),
                  );
                }),
            AnimatedServiceItem(
                index: 4,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FAQScreen()),
                  );
                }),
            AnimatedServiceItem(
                index: 5,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PredictionPageresult()),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class AnimatedServiceItem extends StatefulWidget {
  final int index;
  final VoidCallback onTap;

  AnimatedServiceItem({required this.index, required this.onTap});

  @override
  _AnimatedServiceItemState createState() => _AnimatedServiceItemState();
}

class _AnimatedServiceItemState extends State<AnimatedServiceItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return SlideTransition(
            position: _slideAnimation,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.orange, width: 3),
                borderRadius: BorderRadius.circular(30.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Image.asset(
                      _getImageByIndex(widget.index),
                      height: 75,
                      width: 75,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              _getTitleByIndex(widget.index),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getImageByIndex(int index) {
    switch (index) {
      case 0:
        return 'assets/images/watch1.jpeg';
      case 1:
        return 'assets/images/services2.jpg';
      case 2:
        return 'assets/images/services3.jpg';
      case 3:
        return 'assets/images/connetct_doctor.png';
      case 4:
        return 'assets/images/FAQ.jpeg';
      case 5:
        return 'assets/images/pred.png';
      default:
        return '';
    }
  }

  String _getTitleByIndex(int index) {
    switch (index) {
      case 0:
        return 'Taking health information using a smartwatch';
      case 1:
        return 'Scheduling medication times';
      case 2:
        return 'Health reports';
      case 3:
        return 'connect with doctors';
      case 4:
        return 'FAQ Questions';
      case 5:
        return 'My previous predictions';
      default:
        return '';
    }
  }
}
