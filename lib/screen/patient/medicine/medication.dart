import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:watch3/controller/genral_controller.dart';

class MedicationReminderScreen extends StatefulWidget {
  @override
  _MedicationReminderScreenState createState() =>
      _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  String _selectedMedicationType = '';
  String _otherMedicationName = '';
  String _medicineName = '';
  String Note = '';
  String _medicationType = '';
  TextEditingController _controller = TextEditingController(text: '1');
  ApiService medictionnn = ApiService();

  String _selectedDaysWeekString = '';

  String _selectedDaysMounthString = '';
  int _quantity = 1;
  bool _showWeekDaySelection = false;
  bool _showErrorMessage = false;
  TimeOfDay _selectedTime = TimeOfDay(hour: 8, minute: 0);
  String _frequency = 'Every day';
  DateTime? _startDate;
  DateTime? _endDate;
  String selectedValue = 'mg';
  List<String> _weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  Map<String, bool> _selectedDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  Future<DateTime?> _showCustomDatePicker(BuildContext context) async {
    DateTime? selectedDate;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Date'),
          content: Container(
            height: 300.0,
            width: 300.0,
            child: CalendarDatePicker(
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              onDateChanged: (DateTime date) {
                selectedDate = date;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                if (selectedDate != null) {
                  Navigator.of(context).pop(selectedDate);
                } else {
                  // Show error message
                }
              },
            ),
          ],
        );
      },
    );

    return selectedDate;
  }

  Future<void> _selectDateMonth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDaysMounthString = _dateFormat.format(picked);
      });
    }
  }

  String _getSelectedDays() {
    List<String> selected = [];
    _selectedDays.forEach((day, isSelected) {
      if (isSelected) {
        selected.add(day);
      }
    });
    return selected.isEmpty ? '' : selected.join(', ');
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0165FC),
        title: Text(
          'Add a reminder for your medication',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: EdgeInsets.all(5),
          children: <Widget>[
            Text(
              'Medication type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Wrap(
                  spacing: 15.0,
                  runSpacing: 10.0,
                  children: <Widget>[
                    FilterChip(
                      label: Container(
                        child: Text('Glucose'),
                        width: 100,
                      ),
                      selected: _selectedMedicationType == 'Glucose',
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedMedicationType = selected ? 'Glucose' : '';
                          _medicationType = _selectedMedicationType;
                        });
                      },
                      avatar: Icon(Icons.local_drink),
                      selectedColor: Colors.blue.shade100,
                    ),
                    FilterChip(
                      label: Container(
                        child: Text('Pressure'),
                        width: 100,
                      ),
                      selected: _selectedMedicationType == 'Pressure',
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedMedicationType = selected ? 'Pressure' : '';
                          _medicationType = _selectedMedicationType;
                        });
                      },
                      avatar: Icon(
                        Icons.healing,
                      ),
                      selectedColor: Colors.blue.shade100,
                    ),
                  ],
                ),
                SizedBox(height: 10), // مساحة إضافية بين الشريحة وأي عناصر أخرى
                Stack(
                  children: [
                    FilterChip(
                      label: Container(
                        width: 250, // تعيين الطول المطلوب
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Other'),
                            Icon(Icons.electric_bolt_sharp),
                          ],
                        ),
                      ),
                      selected: _selectedMedicationType == 'Other',
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedMedicationType = selected ? 'Other' : '';
                          if (!selected) {
                            _otherMedicationName = '';
                          }
                        });
                      },
                      selectedColor: Colors.blue.shade100,
                    ),
                    if (_selectedMedicationType == 'Other')
                      Positioned.fill(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 80.0),
                          child: Align(
                            alignment: Alignment.center,
                            child: TextField(
                              decoration: InputDecoration(
                                // hintText: 'Enter name',
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                              ),
                              onChanged: (text) {
                                setState(() {
                                  _otherMedicationName = text;
                                  _medicationType = _otherMedicationName;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 160,
                      // padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => _selectTime(context),
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Time',
                                border: UnderlineInputBorder(),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(width: 20),
                                  Text('${_selectedTime.format(context)}'),
                                  // تضبط التباعد هنا
                                  Icon(Icons.access_time),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Medicine name',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                    errorText: 'Medicine name cannot be empty',
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _medicineName = value;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 12),
                              Container(
                                height: 50,
                                width: 43,
                                child: TextField(
                                  maxLength: 1,
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    counterText: '',

                                    hintText: '1',
                                    // counterText: '',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 12.0),
                                  ),
                                  keyboardType: TextInputType.number,
                                  //                       onChanged:   (value) {
                                  // setState(() {
                                  //  int _quantity = int.tryParse(value) ?? 0;
                                  // });},
                                ),
                              ),

                              SizedBox(width: 8),

// داخل وظيفة build
                              Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: DropdownButton<String>(
                                  alignment: Alignment.centerRight,
                                  value: selectedValue,
                                  items: <String>['mg', 'ml', 'g']
                                      .map((String value) {
                                    return DropdownMenuItem<String>(
                                      alignment: Alignment.centerRight,
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedValue = newValue!;
                                    });
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _frequency,
                  decoration: InputDecoration(
                    labelText: 'Reminder frequency',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  ),
                  items: <String>['Every day', 'Every week', 'Every month']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) async {
                    setState(() {
                      _frequency = newValue!;
                      _showWeekDaySelection = _frequency == 'Every week';
                    });
                    if (_frequency == 'Every month') {
                      final picked = await _showCustomDatePicker(context);
                      if (picked != null) {
                        setState(() {
                          _selectedDaysMounthString =
                              _dateFormat.format(picked);
                          print('Selected days: ${_selectedDaysMounthString}');
                        });
                      } else {
                        setState(() {});
                      }
                    }
                  },
                ),
                if (_showWeekDaySelection)
                  Column(
                    children: [
                      ..._weekDays.map((day) {
                        return CheckboxListTile(
                          title: Text(day),
                          value: _selectedDays[day],
                          onChanged: (bool? value) {
                            setState(() {
                              _selectedDays[day] = value!;
                            });
                          },
                        );
                      }).toList(),
                      if (_showErrorMessage)
                        Text(
                          'Please select at least one day',
                          style: TextStyle(color: Colors.red),
                        ),
                      ElevatedButton(
                        onPressed: () {
                          if (_selectedDays.values.any((element) => element)) {
                            print('Selected days: ${_getSelectedDays()}');
                            _showWeekDaySelection = false;
                            setState(() {
                              _selectedDaysWeekString = _getSelectedDays();
                              _showErrorMessage = false;
                            });
                          } else {
                            print('Please select at least one day');
                            setState(() {
                              _showErrorMessage = true;
                            });
                          }
                        },
                        child: Text('Save'),
                      ),
                    ],
                  ),
                if (!_showWeekDaySelection && _frequency == 'Every week')
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Selected days: ${_getSelectedDays()}',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                if (_frequency == 'Every month' &&
                    _selectedDaysMounthString.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      'Selected date: $_selectedDaysMounthString',
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(
                                color: Colors.transparent)), // تخفي حواف اليمين
                      ),
                      child: ElevatedButton(
                        onPressed: () =>
                            _selectDate(context, isStartDate: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          _startDate == null
                              ? 'اختر تاريخ البداية'
                              : 'تاريخ البداية: ${_dateFormat.format(_startDate!)}',
                        ),
                      ),
                    ),
                  ),
                  if (_startDate != null)
                    Container(
                      width: 1,
                      color: Colors.black,
                      height: 50,
                    ),
                  if (_startDate != null)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color:
                                      Colors.transparent)), // تخفي حواف اليسار
                        ),
                        child: ElevatedButton(
                          onPressed: _startDate == null
                              ? null
                              : () => _selectDate(context, isStartDate: false),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            _endDate == null
                                ? 'اختر تاريخ النهاية'
                                : 'تاريخ النهاية: ${_dateFormat.format(_endDate!)}',
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextField(
              maxLength: 300,
              decoration: InputDecoration(
                labelText: 'Note',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  Note = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_startDate != null && _endDate != null) {
                  int _quantity = int.tryParse(_controller.text) ?? 0;

                  medictionnn.medicenMethod(
                      _medicationType,
                      _selectedTime.format(context),
                      _medicineName,
                      _quantity,
                      selectedValue,
                      _frequency,
                      _selectedDaysWeekString,
                      _selectedDaysMounthString,
                      _dateFormat.format(_startDate!),
                      _dateFormat.format(_endDate!),
                      Note,
                      context);
                  print(' Time:${_selectedTime.format(context)}');
                  print(_selectedDaysMounthString);
                  print(_selectedDaysWeekString);
                  print(_startDate);
                  print(selectedValue);
                  print(Note);
                  print(_medicationType);
                  print(_medicineName);
                  print(_quantity);
                  print('تاريخ البداية: ${_dateFormat.format(_startDate!)}');
                  print('تاريخ النهاية: ${_dateFormat.format(_endDate!)}');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "الرجاء تحديد تاريخ البداية والنهاية",
                        style: TextStyle(color: Colors.yellow),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                  );
                  print('الرجاء تحديد تاريخ البداية والنهاية');
                }
                if (_medicineName.isEmpty || _quantity == 0) {
                  // عرض النص فقط عندما تكون كل الحقول فارغة
                  Text(
                    'Medicine name and quantity cannot be empty',
                    style: TextStyle(color: Colors.red),
                  );
                } else {
                  // Save the reminder
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context,
      {required bool isStartDate}) async {
    DateTime initialDate = DateTime.now();
    if (!isStartDate && _startDate != null) {
      initialDate = _startDate!.add(Duration(days: 1));
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: isStartDate ? DateTime.now() : _startDate!,
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          _endDate = null;
        } else {
          _endDate = picked;
        }
      });
    }
  }
}
