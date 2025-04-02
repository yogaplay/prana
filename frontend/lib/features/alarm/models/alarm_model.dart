class AlarmItem {
  final String title;
  final String message;
  final DateTime  date;
  bool isChecked;

  AlarmItem({
    required this.title,
    required this.message,
    required this.date,
    this.isChecked = false,
  });

  // JSON 변환
  Map<String, dynamic> toJson() => {
    'title': title,
    'message': message,
    'date': date.toIso8601String(),
    'isChecked': isChecked,
  };

  // JSON에서 객체로 변환
  factory AlarmItem.fromJson(Map<String, dynamic> json) {
    return AlarmItem(
      title: json['title'],
      message: json['message'],
      date: DateTime.parse(json['date']),
      isChecked: json['isChecked'] ?? false,
    );
  }
}