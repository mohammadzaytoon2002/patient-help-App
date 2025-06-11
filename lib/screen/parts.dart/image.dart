import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  File? _image;

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Picker Demo'),
      ),
      body:    GenderSelectionWidget(),
   
    );
  }
}


 GlobalKey<FormState> genderKey = GlobalKey<FormState>();


class GenderSelectionWidget extends StatefulWidget {
  @override
  _GenderSelectionWidgetState createState() => _GenderSelectionWidgetState();
}

class _GenderSelectionWidgetState extends State<GenderSelectionWidget> {
 
  bool _isMaleSelected = false;
  bool _isFemaleSelected = false;




String? validateGender(String? value) {
  if (!_isMaleSelected && !_isFemaleSelected) {
    return 'Please select your gender';
  } 
  return null;
}

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Select Gender:',
          style: TextStyle(fontSize: 16),
        ),
        Form(
  key: genderKey,
  
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      InkWell(
        onTap: () {
          setState(() {
            _isMaleSelected = true;
            _isFemaleSelected = false;
          });
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: 'male',
                groupValue: _isMaleSelected ? 'male' : null,
                onChanged: (value) {
                  setState(() {
                    _isMaleSelected = true;
                    _isFemaleSelected = false;
                  });
                },
              ),
              Text('Male'),
            ],
          ),
        ),
      ),
      SizedBox(width: 16),
      InkWell(
        onTap: () {
          setState(() {
            _isMaleSelected = false;
            _isFemaleSelected = true;
          });
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: 'female',
                groupValue: _isFemaleSelected ? 'female' : null,
                onChanged: (value) {
                  setState(() {
                    _isMaleSelected = false;
                    _isFemaleSelected = true;
                  });
                },
              ),
              Text('Female'),
            ],
          ),
        ),
      ),
    ],
  ),
),
      ],
    );
  }
}

//  Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Picker Demo'),
//       ),
//       body: 
//       // Center(
//       //   child: _image == null
//       //       ? Text('No image selected.')
//       //       : Image.file(_image!),
//       // ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: _getImage,
//       //   tooltip: 'Pick Image',
//       //   child: Icon(Icons.edit),
//       // ),
      
//     );
//   }
// }

  // Form(
  //                     key: emailKey,
  //                     child: TextFormField(
  //                       controller: _emailController,
  //                       decoration: InputDecoration(
  //                         labelText: 'Email',
  //                         hintText: 'Enter your email',
  //                         prefixIcon: Icon(
  //                           Icons.email,
  //                           color: Styles.c1,
  //                         ),
  //                         contentPadding: EdgeInsets.symmetric(horizontal: 20.0,),
  //                         enabledBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(
  //                             color: Colors.grey[500]!,
  //                           ),
  //                           borderRadius: BorderRadius.circular(20.0),
  //                         ),
  //                         focusedBorder: OutlineInputBorder(
  //                           borderSide: BorderSide(
  //                             color: Styles.primaryColor,
  //                           ),
  //                           borderRadius: BorderRadius.circular(10.0),
  //                         ),
  //                         fillColor: Colors.white,
  //                         filled: true,
  //                       ),
  //                       validator: (value) {
  //                         if (value == null || value.isEmpty) {
  //                           return 'Please enter your email';
  //                         }
  //                         final RegExp emailRegex =
  //                             RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  //                         if (!emailRegex.hasMatch(value)) {
  //                           return 'Check your email';
  //                         }
  //                         return null;
  //                       },
  //                       onSaved: (value) {
  //                         _email = value;
  //                       },
  //                     ),
  //                   ),