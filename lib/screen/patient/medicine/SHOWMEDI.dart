import 'package:flutter/material.dart';
import 'package:watch3/controller/genral_controller.dart';
import 'package:watch3/screen/models/medicin.dart';
import 'package:watch3/screen/patient/medicine/medication.dart';

class ShowMedication extends StatefulWidget {
  @override
  _ShowMedicationState createState() => _ShowMedicationState();
}

class _ShowMedicationState extends State<ShowMedication> {
  List<Medication> medications = [];
  late Future<void> _medicationsFuture;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _medicationsFuture = fetchMedications();
  }

  Future<void> fetchMedications() async {
    try {
      medications = await apiService.showMedications();
    } catch (e) {
      // Handle error here, if needed
      print('Error fetching medications: $e');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Scheduling medication',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF0165FC),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MedicationReminderScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0165FC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Add new medicine',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _medicationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (medications.isEmpty) {
                    return Center(child: Text('No medications found'));
                  }
                  return ListView.builder(
                    itemCount: medications.length,
                    padding: EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12.0),
                                color: Color(0xFF0165FC),
                                width: double.infinity,
                                child: Text(
                                  medications[index].time,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          medications[index].name,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 180,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: medications[index]
                                                    .pill
                                                    .toString(),
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              TextSpan(
                                                text: ' pill ',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              ),
                                              // WidgetSpan(
                                              //   child: SizedBox(width: 100),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Frequency: ',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(width: 180),
                                          ),
                                          TextSpan(
                                            text: medications[index].type,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Start date: ',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(width: 180),
                                          ),
                                          TextSpan(
                                            text: medications[index]
                                                .timeRangeStart,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'End date: ',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(width: 185),
                                          ),
                                          TextSpan(
                                            text:
                                                medications[index].timeRangeEnd,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    fixedSize: Size(150, 36),
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.white),
                                        onPressed: () {
                                          apiService.DeletMedications(
                                                  medications[index].id)
                                              .then((_) {
                                            setState(() {
                                              // تحديث القائمة بعد حذف العنصر
                                              medications.removeAt(index);
                                            });
                                            // عرض رسالة للمستخدم بنجاح الحذف
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Medication deleted successfully'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }).catchError((error) {
                                            print(
                                                'Error deleting medication: $error');
                                            // عرض رسالة للمستخدم في حالة حدوث خطأ
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Failed to delete medication'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          });
                                        },
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
