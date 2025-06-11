class Medication {
  final int id;
  final String type;
  final String name;
  final int pill;
  final String unit;
  final String freq;
  final String time;
  final String? specificDayWeek;
  final String? specificDayMonth;
  final String timeRangeStart;
  final String timeRangeEnd;
  final String note;

  Medication({
    required this.id,
    required this.type,
    required this.name,
    required this.pill,
    required this.unit,
    required this.freq,
    required this.time,
    required this.specificDayWeek,
    required this.specificDayMonth,
    required this.timeRangeStart,
    required this.timeRangeEnd,
    required this.note,
  });

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['id'] ?? 0, // تعويض قيمة 'null' بصفر مثلاً
      type: json['type'] ?? '', // تعويض قيمة 'null' بسلسلة فارغة
      name: json['name'] ?? '',
      pill: json['pill'] ?? 0,
      unit: json['unit'] ?? '',
      freq: json['freq'] ?? '',
      time: json['time'] ?? '',
      specificDayWeek: json['specific_day_week'] ?? '',
      specificDayMonth: json['specific_day_month'] ?? '',
      timeRangeStart: json['time_range_start'] ?? '',
      timeRangeEnd: json['time_range_end'] ?? '',
      note: json['note'] ?? '',
    );
  }
}
