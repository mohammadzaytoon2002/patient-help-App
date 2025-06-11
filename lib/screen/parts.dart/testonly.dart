import 'package:flutter/material.dart';

class EmailSelectionScreen extends StatefulWidget {
  @override
  _EmailSelectionScreenState createState() => _EmailSelectionScreenState();
}

class _EmailSelectionScreenState extends State<EmailSelectionScreen> {

  String? _groupValue; // متغير لتخزين قيمة المجموعة
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Rent'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Radio(
                value: 'male',
                groupValue: _groupValue,
                onChanged: (value) {
                  setState(() {
                                          _isSelected = false;

                    _groupValue = value.toString(); // تحديث قيمة المجموعة لتكون String
                  });
                },
              ),
              Text('Male'),
                Radio(
                value: 'female',
                groupValue: _groupValue,
                onChanged: (value) {
                  setState(() {
                      _isSelected = false;
                    _groupValue = value.toString(); // تحديث قيمة المجموعة لتكون String
                  });
                },
              ),
              
              Text('Female'),
              
              Visibility(
      visible: _isSelected,
      child: Text(
        'Please select an option',
        style: TextStyle(color: Colors.red),
      ),),
            ],
          ),
          
          
            
          ElevatedButton(
            onPressed: () {
              if (_groupValue == null) {
                setState(() {
                  _isSelected = true;
                });
              } 
            },
            child: Text('Check Selection'),
          ),
       
        ],
      ),
    );
  }
}
