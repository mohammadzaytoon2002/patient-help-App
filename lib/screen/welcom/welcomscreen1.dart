import 'package:watch3/main.dart';
import 'package:watch3/screen/welcom/welcomscreen2.dart';
import 'package:flutter/material.dart';

class WelcomePage1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WelcomePage2()),
              );
            },
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Expanded(
              flex: 1,
              child: Image.asset(
                'assets/images/welcom1.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'prediction of ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'hereditary Diabetes',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          // SizedBox(height: 10),
          // Text(
          //   'medicines',
          //   style: TextStyle(
          //     color: Colors.blue,
          //     fontSize: 24,
          //     fontWeight: FontWeight.bold,
          //   ),
          // ),
          SizedBox(height: 10),
          Text(
            'You can predict diabetes through some information from the parents',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 4),
              CircleAvatar(
                radius: 8,
                backgroundColor: Colors.blue[800],
              ),
              CircleAvatar(
                radius: 8,
                backgroundColor: Colors.grey[400],
              ),
              SizedBox(width: 4),
              CircleAvatar(
                radius: 8,
                backgroundColor: Colors.grey[400],
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0), // قم بتعديل هذا الرقم حسب الفارق الذي ترغب به
                // child: Container(
                //   decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     color: Colors.black,
                //   ),
                //   child: IconButton(
                //     onPressed: () {
                //       // Handle back action
                //     },
                //     icon: Icon(
                //       Icons.arrow_back,
                //       color: Colors.white, // تغيير لون السهم إلى اللون الأبيض
                //     ),
                //   ),
                // ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WelcomePage2()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
