import 'package:flutter/material.dart';

class AllMedicationsPage extends StatelessWidget {
  final List medications;

  AllMedicationsPage({required this.medications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Medications'),
      ),
      body: ListView.builder(
        itemCount: medications.length,
        itemBuilder: (context, index) {
          final medication = medications[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              title: Text(
                medication['name'],
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text('Type: ${medication['type']}'),
                  SizedBox(height: 4.0),
                  Text('Pill: ${medication['pill']} mg'),
                  SizedBox(height: 4.0),
                  Text('Frequency: ${medication['freq']}'),
                  SizedBox(height: 4.0),
                  Text('Time: ${medication['time']}'),
                  SizedBox(height: 4.0),
                  Text(
                      'Specific Day of Month: ${medication['specific_day_month'] ?? 'N/A'}'),
                  SizedBox(height: 4.0),
                  Text('Note: ${medication['note']}'),
                  SizedBox(height: 8.0),
                ],
              ),
              onTap: () {
                // Implement navigation or further action if needed
              },
            ),
          );
        },
      ),
    );
  }
}
