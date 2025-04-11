class YogaItem {
  final int id;
  final String title;
  final String duration;
  final String imageUrl;

  YogaItem({
    required this.id,
    required this.title,
    required this.duration,
    required this.imageUrl,
  });

  factory YogaItem.fromJson(Map<String, dynamic> json) {
    return YogaItem(
      id: json['sequenceId'] ?? 0,
      title: json['sequenceName'] ?? '제목 없음',
      duration: '${json['sequenceTime'] ~/ 60}분',
      imageUrl: json['image'] ?? 'https://picsum.photos/100/150',
    );
  }
}
