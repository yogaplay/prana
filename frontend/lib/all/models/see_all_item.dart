class SeeAllItem {
  final int sequenceId;
  final String sequenceName;
  final List<String> tags;
  final String image;

  SeeAllItem({
    required this.sequenceId,
    required this.sequenceName,
    required this.tags,
    required this.image,
  });

  factory SeeAllItem.fromJson(Map<String, dynamic> json) {
    return SeeAllItem(
      sequenceId: json['sequenceId'],
      sequenceName: json['sequenceName'],
      tags: List<String>.from(json['tags']),
      image: json['image'] ?? 'https://picsum.photos/100',
    );
  }
}
