class YogaSearchResult {
  final int sequenceId;
  final String sequenceName;
  final String image;
  final List<String> tagList;

  YogaSearchResult({
    required this.sequenceId,
    required this.sequenceName,
    required this.image,
    required this.tagList,
  });

  factory YogaSearchResult.fromJson(Map<String, dynamic> json) {
    return YogaSearchResult(
      sequenceId: json['sequenceId'],
      sequenceName: json['sequenceName'],
      image: json['image'] ?? 'https://picsum.photos/100',
      tagList: List<String>.from(json['tagList']),
    );
  }
}
