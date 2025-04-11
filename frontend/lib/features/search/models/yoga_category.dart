import 'package:frontend/features/search/models/yoga_sequence.dart';

class YogaCategory {
  final String tagName;
  final String tagType;
  final List<YogaSequence> items;

  YogaCategory({
    required this.tagName,
    required this.tagType,
    required this.items,
  });

  factory YogaCategory.fromJson(Map<String, dynamic> json) {
    return YogaCategory(
      tagName: json['tagName'],
      tagType: json['tagType'],
      items:
          (json['sampleList'] as List)
              .map((item) => YogaSequence.fromJson(item))
              .toList(),
    );
  }
}
