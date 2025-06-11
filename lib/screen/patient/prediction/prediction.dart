import 'package:watch3/componant/shape.dart';
import 'package:flutter/material.dart';
import 'package:watch3/screen/patient/prediction/prediction2.dart';
import 'package:watch3/screen/patient/prediction/prediction3.dart';
import 'package:watch3/screen/patient/prediction/prediction_feed.dart';
import 'package:watch3/screen/patient/prediction/prediction_retina.dart';

class PredictionPage extends StatelessWidget {
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
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prediction',
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
                  height: 120,
                  width: 120,
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
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
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   border: Border.all(color: Colors.orange),
                //   borderRadius: BorderRadius.circular(20.0),
                // ),
                // margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/predict1.jpg',
                        height: 150,
                        width: 150,
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
                                'Prediction of Diabetes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'in general ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            // Text(
                            //   'Description: You can predict diabetes if you suspect the presence of this disease with some simple information that we need in order for the prediction process to take place',
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //   ),
                            // ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: 200,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PredictionPage2()),
                                    );
                                  },
                                  child: Text('Try It',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        Size(150.0, 25.0)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                    // يمكنك إضافة المزيد من الخصائص هنا حسب احتياجاتك
                                  ),
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
            ),
            SizedBox(height: 10),
            SizedBox(
              width: MediaQuery.of(context).size.width,
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
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                //    margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/predict2.jpg',
                        height: 150,
                        width: 150,
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
                                'Genetic Prediction of',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Diabetes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            // Text(
                            //   'Description: Just enter the basic information about the father’s and mother’s genes and some basic information, and you can predict whether your child will develop diabetes or not.',
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //   ),
                            // ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: 200,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PredictionPage3()),
                                    );
                                  },
                                  child: Text('Try It',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        Size(150.0, 25.0)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                    // يمكنك إضافة المزيد من الخصائص هنا حسب احتياجاتك
                                  ),
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
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
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
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                //    margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/feedp.jpg',
                        height: 150,
                        width: 150,
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
                                'diabetic foot ulcer',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                ' (DFU)',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            // Text(
                            //   'Description: Just enter the basic information about the father’s and mother’s genes and some basic information, and you can predict whether your child will develop diabetes or not.',
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //   ),
                            // ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: 200,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Predictionfeed()),
                                    );
                                  },
                                  child: Text('Try It',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        Size(150.0, 25.0)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                    // يمكنك إضافة المزيد من الخصائص هنا حسب احتياجاتك
                                  ),
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
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
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
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                //    margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Image.asset(
                        'assets/images/eye.png',
                        height: 150,
                        width: 150,
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
                                'Retina Prediction of',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Center(
                              child: Text(
                                'Diabetes',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 5),
                            // Text(
                            //   'Description: Just enter the basic information about the father’s and mother’s genes and some basic information, and you can predict whether your child will develop diabetes or not.',
                            //   style: TextStyle(
                            //     fontSize: 14,
                            //   ),
                            // ),
                            SizedBox(height: 10),
                            SizedBox(
                              width: 200,
                              child: Center(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RetinaAlert()),
                                    );
                                  },
                                  child: Text('Try It',
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white)),
                                  style: ButtonStyle(
                                    fixedSize: MaterialStateProperty.all(
                                        Size(150.0, 25.0)),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.blue),
                                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
