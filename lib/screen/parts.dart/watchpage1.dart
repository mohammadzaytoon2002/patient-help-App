import 'package:flutter/material.dart';
import 'package:health/health.dart';

class MyHomePageWatch extends StatefulWidget {
  const MyHomePageWatch({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePageWatch> createState() => _MyHomePageWatchState();
}

class _MyHomePageWatchState extends State<MyHomePageWatch> {
  int _counter = 0;
  HealthFactory health = HealthFactory();
  List<Map<String, dynamic>> healthDataPoints = [];

  final Map<HealthDataType, Color> dataTypeColorMap = {
    HealthDataType.STEPS: Colors.blue,
    HealthDataType.HEART_RATE: Colors.red,
    HealthDataType.ACTIVE_ENERGY_BURNED: Colors.green,
    HealthDataType.BLOOD_GLUCOSE: Colors.orange,
    HealthDataType.BLOOD_OXYGEN: Colors.purple,
    HealthDataType.BODY_FAT_PERCENTAGE: Colors.yellow,
    HealthDataType.BODY_TEMPERATURE: Colors.teal,
    HealthDataType.HEIGHT: Colors.pink,
    HealthDataType.WEIGHT: Colors.indigo,
    HealthDataType.WATER: Colors.cyan,
  };

  @override
  void initState() {
    super.initState();
    _initializeHealthData();
  }

  Future<void> _initializeHealthData() async {
    try {
      bool isAuthorized = await _requestAuthorization();
      if (isAuthorized) {
        await _fetchHealthData();
      } else {
        print("Authorization not granted");
      }
    } catch (e) {
      print("Error initializing health data: $e");
    }
  }

  Future<bool> _requestAuthorization() async {
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.BLOOD_GLUCOSE,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BODY_TEMPERATURE,
      HealthDataType.HEIGHT,
      HealthDataType.WEIGHT,
      HealthDataType.WATER,
    ];
    return await health.requestAuthorization(types);
  }

  Future<void> _fetchHealthData() async {
    try {
      List<HealthDataType> types = [
        HealthDataType.STEPS,
        HealthDataType.HEART_RATE,
        HealthDataType.ACTIVE_ENERGY_BURNED,
        HealthDataType.BLOOD_GLUCOSE,
        HealthDataType.BLOOD_OXYGEN,
        HealthDataType.BODY_FAT_PERCENTAGE,
        HealthDataType.BODY_TEMPERATURE,
        HealthDataType.HEIGHT,
        HealthDataType.WEIGHT,
        HealthDataType.WATER,
      ];
      DateTime now = DateTime.now();
      DateTime start = DateTime(now.year, now.month, now.day);
      DateTime end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        start,
        end,
        types,
      );
      if (healthData.isEmpty) {
        print("No health data found");
      } else {
        for (var dataPoint in healthData) {
          String formattedDateTime =
              "${dataPoint.dateFrom.year}-${dataPoint.dateFrom.month}-${dataPoint.dateFrom.day} ${dataPoint.dateFrom.hour}:${dataPoint.dateFrom.minute}";
          healthDataPoints.add({
            'value': dataPoint.value,
            'unit': dataPoint.unit,
            'date': formattedDateTime,
            'type': dataPoint.type,
            'color': dataTypeColorMap[dataPoint.type] ?? Colors.black,
          });
        }
        setState(() {});
      }
    } catch (e) {
      print("Error fetching health data: $e");
    }
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Health Data:',
            ),
            healthDataPoints.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: healthDataPoints.length,
                      itemBuilder: (context, index) {
                        final data = healthDataPoints[index];
                        return ListTile(
                          title: Text(
                            "Value: ${data['value']}, Unit: ${data['unit']}, Date: ${data['date']}, Type: ${data['type']}",
                            style: TextStyle(color: data['color']),
                          ),
                        );
                      },
                    ),
                  )
                : const Text('Fetching health data...'),
          ],
        ),
      ),
    );
  }
}
