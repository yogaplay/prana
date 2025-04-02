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
      id: json['sequence_id'],
      title: json['sequence_name'],
      duration: '${json['sequence_time']}분',
      imageUrl: json['image'],
    );
  }
}
