// import 'package:watch3/componant/constant.dart';
// import 'package:watch3/screen/patient/register.dart';
// import 'package:flutter/material.dart';

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               alignment: Alignment.center,
//               padding: EdgeInsets.symmetric(vertical: 50.0),
//               child: Column(
//                 children: [
//                   CircleAvatar(
//                     backgroundImage: AssetImage('assets/images/logo.png'),
//                     radius: 50.0,
//                   ),
//                   SizedBox(height: 10.0),
//                   Text(
//                     'Log In',
//                     style: TextStyle(
//                       color: Styles.primaryColor,
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Divider(
//                     color: Styles.primaryColor,
//                     thickness: 2.0,
//                     indent: 50.0,
//                     endIndent: 50.0,
//                   ),
//                   SizedBox(height: 10.0),
//                   Text(
//                     'Log in to your account',
//                     style: TextStyle(
//                       color: Styles.primaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: 'User Name',
//                       hintText: 'Enter your user name',
//                       prefixIcon: Icon(
//                         Icons.person,
//                         color: Styles.c1,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 15.0),
//                   TextFormField(
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       labelText: 'Password',
//                       hintText: 'Enter your password',
//                       prefixIcon: Icon(
//                         Icons.lock,
//                         color: Styles.c1,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 10.0),
//                   Align(
//                     alignment: Alignment.centerRight,
//                     child: TextButton(
//                       onPressed: () {
//                         // Handle forget password action
//                       },
//                       child: Text(
//                         'Forget your password?',
//                         style: TextStyle(
//                           color: Styles.primaryColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20.0),
//                   Align(
//                     alignment: Alignment.center,
//                     child: SizedBox(
//                       width: size.width * 0.6,
//                       height: 40.0, // Use fixed height value
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Handle login action
//                         },
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.all(Styles.primaryColor),
//                         ),
//                         child: Text(
//                           'LOGIN',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: size.height * 0.03),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Don't have an account? ",
//                         style: TextStyle(
//                           color: Styles.primaryColor,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   SignUpForm(), // استبدل SignUpPage() بصفحة التسجيل الخاصة بك
//                             ),
//                           );
//                         },
//                         child: Text(
//                           'Create',
//                           style: TextStyle(
//                             color: Styles.primaryColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 2.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Are you a doctor ? ",
//                         style: TextStyle(
//                           color: Styles.primaryColor,
//                         ),
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) =>
//                                   SignUpForm(), // استبدل SignUpPage() بصفحة التسجيل الخاصة بك
//                             ),
//                           );
//                         },
//                         child: Text(
//                           'Log in ',
//                           style: TextStyle(
//                             color: Styles.primaryColor,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10.0),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           // Handle Facebook login action
//                         },
//                         icon: Icon(Icons.facebook),
//                         color: Colors.blue,
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           // Handle Google login action
//                         },
//                         icon: Icon(Icons.face),
//                         color: Colors.red,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
