import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import 'package:watch3/controller/genral_controller.dart';

class verify_forgetPass extends StatefulWidget {
  const verify_forgetPass({Key? key}) : super(key: key);

  @override
  State<verify_forgetPass> createState() => _verify_forgetPassState();
}

class _verify_forgetPassState extends State<verify_forgetPass> {
  String pinCode = '';

  ApiService verifyyForget = ApiService();
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
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('verification'),
        centerTitle: true,
      ),
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
                  'assets/hotmail.jpg', // استبدل هذا بمسار الصورة في مشروعك
                  width: 100, // يمكنك تعديل حجم الصورة حسب الحاجة
                  height: 100,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 40),
                child: const Text(
                  "Enter the code sent to your number",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: const Text(
                  "+952627225",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
              ),
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
                    onPressed: () {},
                    child: Text(
                      'Resend code',
                      style: TextStyle(color: Colors.blue), // تعيين لون النص
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await verifyyForget.restemail_pass_verifyMethod(
                          pinCode, context);
                      print(defaultPinTheme);

                      //   // إجراءات عند النقر على الزر الثاني
                      // },
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
                      pinCode;
                    },
                    child: Text(
                      'change email',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40, left: 30, right: 30),
                    child: Divider(
                      indent: 5,
                      color: Colors.black,
                      thickness: 2,
                    ),
                  ),
                  Divider(
                    height: 0.001,
                    color: Colors.green, // لون الخط
                    thickness: 1, // سمك الخط
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
