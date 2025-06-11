import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch3/componant/shape%20copy.dart';

class PredictionResultPage extends StatefulWidget {
  final int patientId;

  const PredictionResultPage({required this.patientId});

  @override
  _PredictionResultPageState createState() => _PredictionResultPageState();
}

class _PredictionResultPageState extends State<PredictionResultPage> {
  String token = "";
  List dfuPredictions = [];
  List diabetesPredictions = [];
  List genomicPredictions = [];
  List retinaPredictions = [];

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? "";
    });
    _fetchPredictions();
  }

  _fetchPredictions() async {
    try {
      var dfuResponse = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/getpredict_dfu/${widget.patientId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      var diabetesResponse = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/getpredictdiabetes/${widget.patientId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      var genomicResponse = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/getpredictgenomic/${widget.patientId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      var retinaResponse = await http.get(
        Uri.parse(
            'http://192.168.1.107:8000/api/from_doctor/getpredict_retina/${widget.patientId}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (dfuResponse.statusCode == 200) {
        var dfuData = json.decode(dfuResponse.body);
        setState(() {
          dfuPredictions = dfuData['DfuPredictionResults'];
        });
      } else {
        print('Error fetching DFU predictions: ${dfuResponse.body}');
      }

      if (diabetesResponse.statusCode == 200) {
        var diabetesData = json.decode(diabetesResponse.body);
        setState(() {
          diabetesPredictions = diabetesData['DiabetesPredictionResults'];
        });
      } else {
        print('Error fetching diabetes predictions: ${diabetesResponse.body}');
      }

      if (genomicResponse.statusCode == 200) {
        var genomicData = json.decode(genomicResponse.body);
        setState(() {
          genomicPredictions = genomicData['GenomicPredictionResults'];
        });
      } else {
        print('Error fetching genomic predictions: ${genomicResponse.body}');
      }
      if (retinaResponse.statusCode == 200) {
        var retinaData = json.decode(retinaResponse.body);
        setState(() {
          retinaPredictions = retinaData['retinaPredictionResults'];
        });
      } else {
        print('Error fetching retina predictions: ${retinaResponse.body}');
      }
    } catch (e) {
      print('Error fetching predictions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250.0),
        child: AppBar(
          backgroundColor: Color.fromARGB(255, 3, 88, 128),
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
              Column(
                children: [
                  Text(
                    'prediction result ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    'for patient ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ],
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
                  height: 100,
                  width: 100,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              predictionSection(
                'Genetic prediction of diabetes:',
                genomicPredictions,
                Colors.blue,
                Colors.white,
                'GenomicPredictionResults',
              ),
              predictionSection(
                'Prediction of diabetes in general:',
                diabetesPredictions,
                Colors.teal,
                Colors.white,
                'DiabetesPredictionResults',
              ),
              predictionSectionWithImage(
                'Prediction by diabetic foot:',
                dfuPredictions,
                Colors.green,
                Colors.white,
                'DfuPredictionResults',
              ),
              predictionSectionWithImage(
                'Retina Prediction:',
                retinaPredictions,
                Colors.purple,
                Colors.white,
                'retinaPredictionResults',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget predictionSection(String title, List predictions, Color color1,
      Color color2, String predictionType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (predictions.isEmpty)
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color1),
            ),
            child: Column(
              children: [
                Text(
                  'No predictions available',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                SizedBox(height: 8),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(builder: (context) => PredictionPage()),
                //     );
                //   },
                //   child: Text('Go to Prediction Page'),
                // ),
              ],
            ),
          )
        else
          ...predictions.map((prediction) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(color: color1),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      'created_At: ${prediction['created_at']}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color2,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Result: ',
                            style: TextStyle(color: Colors.red),
                          ),
                          TextSpan(
                            text: '${prediction['prediction_result']}',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget predictionSectionWithImage(String title, List predictions,
      Color color1, Color color2, String predictionType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (predictions.isEmpty)
          Container(
            width: double.infinity,
            margin: EdgeInsets.symmetric(vertical: 8),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color1),
            ),
            child: Column(
              children: [
                Text(
                  'No predictions available',
                  style: TextStyle(fontSize: 16, color: Colors.red),
                ),
                //  SizedBox(height: 8),
                // ElevatedButton(
                //   onPressed: () {
                //     // Navigate to prediction page
                //   },
                //   child: Text('Go to Prediction Page'),
                // ),
              ],
            ),
          )
        else
          ...predictions.map((prediction) {
            String imageUrl = 'http://192.168.1.107:8000${prediction['image']}';
            return Container(
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(color: color1),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color1,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Text(
                      'created_At: ${prediction['created_at']}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color2,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (prediction['image'] != null &&
                            prediction['image'].isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    child: Container(
                                      child: Image.network(imageUrl),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Image.network(
                              imageUrl,
                              height: 50,
                              width: 50,
                            ),
                          )
                        else
                          Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/logo.png', // صورة بديلة
                                height: 30,
                                width: 30,
                              ),
                            ),
                          ),
                        SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Result: ',
                                  style: TextStyle(color: Colors.red),
                                ),
                                TextSpan(
                                  text: '${prediction['prediction_result']}',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }
}
