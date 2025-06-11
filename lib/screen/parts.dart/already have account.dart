import 'package:watch3/componant/constant.dart';
import 'package:flutter/material.dart';
import 'package:watch3/componant/constant.dart';
import 'package:flutter/material.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  final bool login;
  final VoidCallback press;

  const AlreadyHaveAnAccount({
    Key? key,
    required this.login,
    required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          login ? 'Already have an account?' : 'Don\'t have an account?',
          style: TextStyle(color: Styles.primaryColor),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? 'Login' : 'Sign Up',
            style: TextStyle(
              color: Styles.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
