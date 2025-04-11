class WeeklyYogaData {
  final int year;
  final int month;
  final int week;
  final int time;
  final double accurary;
  final double bmi;

  WeeklyYogaData({
    required this.year,
    required this.month,
    required this.week,
    required this.time,
    required this.accurary,
    required this.bmi,
  });

  String get label => '$month월\n$week주차';
}
