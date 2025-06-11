import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/componant/shape.dart';
import 'package:watch3/screen/parts.dart/navigatorbar.dart';
import 'package:watch3/screen/patient/homepage2.dart';

class PredictionPage2 extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage2> {
  String geneInMotherSide = 'yes';
  String geneInFatherSide = 'no';
  String defectInMaternalSide = 'yes';
  String defectInPaternalSide = 'yes';
  String seriousIllnessHistory = 'yes';
  String drugAddictionHistory = 'yes';
  String infertilityTreatmentHistory = 'yes';
  String deformitiesHistory = 'yes';
  int motherAge = 18;
  int fatherAge = 18;
  int deformitiesage = 1;
  late String? token;

  @override
  void initState() {
    super.initState();
    // Initialize values from shared preferences
    _loadToken();
  }

  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
  }

  Future<void> predictGenomic(BuildContext context) async {
    String url = 'http://192.168.1.107:8000/api/predictgenomic';

    var response = await http.post(Uri.parse(url), headers: <String, String>{
      'Authorization': 'Bearer $token',
    }, body: {
      'Genes_Mother_Side': geneInMotherSide,
      'Inherited_Father': geneInFatherSide,
      'Maternal_Gene': defectInMaternalSide,
      'Paternal_Gene': defectInPaternalSide,
      'Mother_Age': motherAge.toString(),
      'Father_Age': fatherAge.toString(),
      'Maternal_Illness': seriousIllnessHistory,
      'Substance_Abuse': drugAddictionHistory,
      'Assisted_Conception': infertilityTreatmentHistory,
      'History_Previous_Pregnancies': deformitiesHistory,
      'Previous_Abortion': deformitiesage.toString(),
    });

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
      print('Failed to predict genomic: ${response.statusCode}');
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
                'Genitic Prediction',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 25.0,
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
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 80, 134, 214)!,
                  Color.fromARGB(255, 154, 201, 239)!
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Is there gene in mother side?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 14, 93, 158),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                  child: ListTile(
                    title: Text('yes'),
                    leading: Radio<String>(
                      value: 'yes',
                      groupValue: geneInMotherSide,
                      onChanged: (String? value) {
                        setState(() {
                          geneInMotherSide = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('no'),
                  leading: Radio<String>(
                    value: 'no',
                    groupValue: geneInMotherSide,
                    onChanged: (String? value) {
                      setState(() {
                        geneInMotherSide = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 80, 134, 214)!,
                  Color.fromARGB(255, 154, 201, 239)!
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Is there gene in father side?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 14, 93, 158),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                  child: ListTile(
                    title: Text('yes'),
                    leading: Radio<String>(
                      value: 'yes',
                      groupValue: geneInFatherSide,
                      onChanged: (String? value) {
                        setState(() {
                          geneInFatherSide = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('no'),
                  leading: Radio<String>(
                    value: 'no',
                    groupValue: geneInFatherSide,
                    onChanged: (String? value) {
                      setState(() {
                        geneInFatherSide = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 80, 134, 214)!,
                  Color.fromARGB(255, 154, 201, 239)!
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Is there defect in patients matemal side of the family?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 14, 93, 158),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                  child: ListTile(
                    title: Text('yes'),
                    leading: Radio<String>(
                      value: 'yes',
                      groupValue: defectInMaternalSide,
                      onChanged: (String? value) {
                        setState(() {
                          defectInMaternalSide = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('no'),
                  leading: Radio<String>(
                    value: 'no',
                    groupValue: defectInMaternalSide,
                    onChanged: (String? value) {
                      setState(() {
                        defectInMaternalSide = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 80, 134, 214)!,
                  Color.fromARGB(255, 154, 201, 239)!
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Is there defect in patients patermal side of the family?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 14, 93, 158),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                child: ListTile(
                  title: Text('yes'),
                  leading: Radio<String>(
                    value: 'yes',
                    groupValue: defectInPaternalSide,
                    onChanged: (String? value) {
                      setState(() {
                        defectInPaternalSide = value!;
                      });
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListTile(
                title: Text('no'),
                leading: Radio<String>(
                  value: 'no',
                  groupValue: defectInPaternalSide,
                  onChanged: (String? value) {
                    setState(() {
                      defectInPaternalSide = value!;
                    });
                  },
                ),
              ),
            )
          ]),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 80, 134, 214)!,
                  Color.fromARGB(255, 154, 201, 239)!
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Does the mother have a history of a serious illness that may lead to major short-term consequences for the birth ?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 14, 93, 158),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                  child: ListTile(
                    title: Text('yes'),
                    leading: Radio<String>(
                      value: 'yes',
                      groupValue: seriousIllnessHistory,
                      onChanged: (String? value) {
                        setState(() {
                          seriousIllnessHistory = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('no'),
                  leading: Radio<String>(
                    value: 'no',
                    groupValue: seriousIllnessHistory,
                    onChanged: (String? value) {
                      setState(() {
                        seriousIllnessHistory = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 80, 134, 214)!,
                  Color.fromARGB(255, 154, 201, 239)!
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Does either parent have a history of drug addiction?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 14, 93, 158),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                  child: ListTile(
                    title: Text('yes'),
                    leading: Radio<String>(
                      value: 'yes',
                      groupValue: drugAddictionHistory,
                      onChanged: (String? value) {
                        setState(() {
                          drugAddictionHistory = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('no'),
                  leading: Radio<String>(
                    value: 'no',
                    groupValue: drugAddictionHistory,
                    onChanged: (String? value) {
                      setState(() {
                        drugAddictionHistory = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 80, 134, 214)!,
                  Color.fromARGB(255, 154, 201, 239)!
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Was any type of infertility treatment used?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 14, 93, 158),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                  child: ListTile(
                    title: Text('yes'),
                    leading: Radio<String>(
                      value: 'yes',
                      groupValue: infertilityTreatmentHistory,
                      onChanged: (String? value) {
                        setState(() {
                          infertilityTreatmentHistory = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('no'),
                  leading: Radio<String>(
                    value: 'no',
                    groupValue: infertilityTreatmentHistory,
                    onChanged: (String? value) {
                      setState(() {
                        infertilityTreatmentHistory = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 80, 134, 214)!,
                  Color.fromARGB(255, 154, 201, 239)!
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Was there any deformities in the mother's previous pregnancies ?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 14, 93, 158),
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50.0, 0, 0, 0),
                  child: ListTile(
                    title: Text('yes'),
                    leading: Radio<String>(
                      value: 'yes',
                      groupValue: deformitiesHistory,
                      onChanged: (String? value) {
                        setState(() {
                          deformitiesHistory = value!;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  title: Text('no'),
                  leading: Radio<String>(
                    value: 'no',
                    groupValue: deformitiesHistory,
                    onChanged: (String? value) {
                      setState(() {
                        deformitiesHistory = value!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            "Mother's age?",
            style: TextStyle(
              color: Color.fromARGB(255, 28, 38, 227),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<int>(
            hint: Text("Age"),
            value: motherAge,
            items: List.generate(83, (index) => index + 18)
                .map((age) => DropdownMenuItem(
                      value: age,
                      child: Text("$age"),
                    ))
                .toList(),
            onChanged: (int? newValue) {
              setState(() {
                motherAge = newValue!;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          SizedBox(height: 16),
          Text(
            "father's age?",
            style: TextStyle(
              color: Color.fromARGB(255, 28, 38, 227),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<int>(
            hint: Text("Age"),
            value: fatherAge,
            items: List.generate(83, (index) => index + 18)
                .map((age) => DropdownMenuItem(
                      value: age,
                      child: Text("$age"),
                    ))
                .toList(),
            onChanged: (int? newValue) {
              setState(() {
                fatherAge = newValue!;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 80, 134, 214)!,
                  Color.fromARGB(255, 154, 201, 239)!
                ],
                begin: Alignment.topLeft,
                end: Alignment.topRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "history of deformities if the mother had any deformities  in her previous pregnancy ",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 14, 93, 158),
              ),
            ),
          ),
          SizedBox(height: 8),
          DropdownButtonFormField<int>(
            hint: Text("Age"),
            value: deformitiesage,
            items: List.generate(83, (index) => index + 1)
                .map((age) => DropdownMenuItem(
                      value: age,
                      child: Text("$age"),
                    ))
                .toList(),
            onChanged: (int? newValue) {
              setState(() {
                deformitiesage = newValue!;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 150, // يجعل العرض ممتدًا ليملأ الشاشة بأكملها
            child: ElevatedButton(
              onPressed: () {
                predictGenomic(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Predict Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
