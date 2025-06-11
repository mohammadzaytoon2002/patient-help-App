import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/screen/parts.dart/navigatorbar.dart';
import 'package:watch3/screen/patient/homepage2.dart';
import 'package:watch3/componant/shape.dart';

class PredictionPage3 extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage3> {
  String gender = 'male';
  String hypertension = 'no';
  String heartDisease = 'no';
  String smokingHistory = 'never';
  int age = 18;
  double bmi = 32.0;
  double hba1c = 6.6;
  double bloodGlucoseLevel = 80;
  String? token;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future<void> predictDiabetes(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    String url = 'http://192.168.1.107:8000/api/predictdiabetes';

    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'gender': gender,
          'age': age.toString(),
          'hypertension': hypertension == 'yes' ? 1 : 0,
          'heart_disease': heartDisease == 'yes' ? 1 : 0,
          'smoking_history': smokingHistory,
          'bmi': bmi.toString(),
          'HbA1c_level': hba1c.toString(),
          'blood_glucose_level': bloodGlucoseLevel.toString(),
        }));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      String? predictionResult = result['predict_Message'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Prediction Result'),
            content: Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$predictionResult',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 24,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomBar(
                              initialIndex: 0,
                            )),
                  );
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      print('Failed to predict diabetes: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }

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
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Prediction in General',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(width: 5),
              Image(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/logo.png'),
                  height: 73,
                  width: 80,
                  color: Color.fromARGB(255, 145, 215, 232).withOpacity(1)),
            ],
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            buildAnimatedContainer('What is your gender?'),
            buildGenderRadioButtons(),
            buildAnimatedContainer(
                'Do you have hypertension (high blood pressure)?'),
            buildYesNoRadioButtons('hypertension'),
            buildAnimatedContainer('Do you have heart disease?'),
            buildYesNoRadioButtons('heartDisease'),
            buildTextInputContainer('How old are you?', 'Enter your age',
                (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your age';
              }
              age = int.tryParse(value) ?? 18;
              return null;
            }),
            buildTextInputContainer(
                'What is your body mass index (BMI)?', 'Enter your BMI',
                (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your BMI';
              }
              bmi = double.tryParse(value) ?? 0.0;
              return null;
            }),
            buildTextInputContainer(
                'What is your HbA1c level?', 'Enter your HbA1c level', (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your HbA1c level';
              }
              hba1c = double.tryParse(value) ?? 0.0;
              return null;
            }),
            buildTextInputContainer('What is your blood glucose level?',
                'Enter your blood glucose level', (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your blood glucose level';
              }
              bloodGlucoseLevel = double.tryParse(value) ?? 0.0;
              return null;
            }),
            buildSmokingHistoryDropdown(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => predictDiabetes(context),
              child: Text('Press for Predict',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAnimatedContainer(String text) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 80, 134, 214),
            Color.fromARGB(255, 154, 201, 239)
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 14, 93, 158),
        ),
      ),
    );
  }

  Widget buildGenderRadioButtons() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
            child: ListTile(
              title: Text('Male'),
              leading: Radio<String>(
                value: 'male',
                groupValue: gender,
                onChanged: (String? value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text('Female'),
            leading: Radio<String>(
              value: 'female',
              groupValue: gender,
              onChanged: (String? value) {
                setState(() {
                  gender = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildYesNoRadioButtons(String groupName) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30.0, 0, 0, 0),
            child: ListTile(
              title: Text('Yes'),
              leading: Radio<String>(
                value: 'yes',
                groupValue:
                    groupName == 'hypertension' ? hypertension : heartDisease,
                onChanged: (String? value) {
                  setState(() {
                    if (groupName == 'hypertension') {
                      hypertension = value!;
                    } else {
                      heartDisease = value!;
                    }
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text('No'),
            leading: Radio<String>(
              value: 'no',
              groupValue:
                  groupName == 'hypertension' ? hypertension : heartDisease,
              onChanged: (String? value) {
                setState(() {
                  if (groupName == 'hypertension') {
                    hypertension = value!;
                  } else {
                    heartDisease = value!;
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget buildTextInputContainer(
      String labelText, String hintText, String? Function(String?)? validator) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 80, 134, 214),
            Color.fromARGB(255, 154, 201, 239)
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget buildSmokingHistoryDropdown() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 80, 134, 214),
            Color.fromARGB(255, 154, 201, 239)
          ],
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: smokingHistory,
        decoration: InputDecoration(
          labelText: 'What is your smoking history?',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        items: <String>['never', 'former', 'current', 'ever', 'not current']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            smokingHistory = newValue!;
          });
        },
      ),
    );
  }
}
