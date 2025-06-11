import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:watch3/controller/genral_controller.dart';
import 'package:watch3/screen/parts.dart/rigester.dart';
import 'package:watch3/screen/patient/register.dart';

class verifyPage extends StatefulWidget {
  const verifyPage({Key? key}) : super(key: key);

  @override
  State<verifyPage> createState() => _verifyPageState();
}

class _verifyPageState extends State<verifyPage> {
  String pinCode = '';
  ApiService watch3y = ApiService();
  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 26,
        color: Colors.grey,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.yellow),
      ),
    );

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.green,
      //   title: const Text('verification'),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          width: double.infinity,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  'assets/images/hotmailVerif.jpeg', // استبدل هذا بمسار الصورة في مشروعك
                  width: 200, // يمكنك تعديل حجم الصورة حسب الحاجة
                  height: 200,
                ),
              ),

              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: const Text(
                  "please enter the 5 digit code sent \nto yourmail@example.com",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              // Container(
              //   margin: const EdgeInsets.only(bottom: 50),
              //   child: const Text(
              //     "+952627225",
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 20,
              //     ),
              //   ),
              // ),
              Pinput(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                length: 5,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.yellow),
                  ),
                ),
                onCompleted: (pin) {
                  pinCode = pin;
                  debugPrint(pin);
                },
              ),
              SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      await watch3y.restemail_Get_verifyMethod(context);
                    },
                    child: Text(
                      'Resend code',
                      style: TextStyle(color: Colors.blue), // تعيين لون النص
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await watch3y.verify(pinCode, context);
                      print(defaultPinTheme);
                    },
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        fontSize: 18, // تغيير حجم النص
                        color: Colors.white, // تغيير لون النص
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color.fromARGB(255, 75, 78, 235),
                      fixedSize: Size(300, 30),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpForm1()),
                      );
                    },
                    child: Text(
                      'change email',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),

                  //                       Divider(
                  //               endIndent: 0.5,
                  //               height: 0.001,
                  //   color: Colors.green, // لون الخط
                  //   thickness: 1, // سمك الخط
                  // ),
                  //            Container(
                  //   margin: EdgeInsets.only(top: 40, left: 30, right: 30),
                  //   child: Divider(
                  //     indent: 5,
                  //     color: Colors.black,
                  //     thickness: 2,
                  //   ),
                  // ),
                  //              Divider(

                  //               height: 0.001,
                  //   color: Colors.green, // لون الخط
                  //   thickness: 1, // سمك الخط
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
