import 'package:frontend/features/search/models/yoga_item.dart';

class YogaSequence {
  final int id;
  final String name;
  final int time;
  final String? imageUrl;

  YogaSequence({
    required this.id,
    required this.name,
    required this.time,
    this.imageUrl,
  });

  factory YogaSequence.fromJson(Map<String, dynamic> json) {
    return YogaSequence(
      id: json['sequenceId'],
      name: json['sequenceName'],
      time: json['sequenceTime'],
      imageUrl: json['sequenceImage'],
    );
  }
}

extension YogaSequenceMapper on YogaSequence {
  YogaItem toYogaItem() {
    return YogaItem(
      title: name,
      duration: "${(time / 60).round()}분",
      imageUrl: imageUrl ?? 'https://picsum.photos/100/150',
    );
  }
}
