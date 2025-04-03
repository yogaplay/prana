class SequenceResultResponse {
  final int sequenceId;
  final String sequenceName;
  final int yogaTime;
  final int sequenceCnt;
  final int totalAccuracy;
  final List<FeedbackItem> totalFeedback;
  final List<RecommendedSequence> recommendSequence;
  final List<PositionAccuracy> positionAccuracy;

  SequenceResultResponse({
    required this.sequenceId,
    required this.sequenceName,
    required this.yogaTime,
    required this.sequenceCnt,
    required this.totalAccuracy,
    required this.totalFeedback,
    required this.recommendSequence,
    required this.positionAccuracy,
  });

  factory SequenceResultResponse.fromJson(Map<String, dynamic> json) {
    return SequenceResultResponse(
      sequenceId: json['sequenceId'],
      sequenceName: json['sequenceName'],
      yogaTime: json['yogaTime'],
      sequenceCnt: json['sequenceCnt'],
      totalAccuracy: json['totalAccuracy'],
      totalFeedback:
          (json['totalFeedback'] as List)
              .map((e) => FeedbackItem.fromJson(e))
              .toList(),
      recommendSequence:
          (json['recommendSequence'] as List)
              .map((e) => RecommendedSequence.fromJson(e))
              .toList(),
      positionAccuracy:
          (json['positionAccuracy'] as List)
              .map((e) => PositionAccuracy.fromJson(e))
              .toList(),
    );
  }
}

class FeedbackItem {
  final String position;
  final int feedbackCnt;

  FeedbackItem({required this.position, required this.feedbackCnt});

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      position: json['position'],
      feedbackCnt: json['feedbackCnt'],
    );
  }
}

class RecommendedSequence {
  final int sequenceId;
  final String sequenceName;
  final int sequenceTime;
  final String sequenceImage;

  RecommendedSequence({
    required this.sequenceId,
    required this.sequenceName,
    required this.sequenceTime,
    required this.sequenceImage,
  });

  factory RecommendedSequence.fromJson(Map<String, dynamic> json) {
    return RecommendedSequence(
      sequenceId: json['sequenceId'],
      sequenceName: json['sequenceName'],
      sequenceTime: json['sequenceTime'],
      sequenceImage: json['sequenceImage'],
    );
  }
}

class PositionAccuracy {
  final int yogaId;
  final String yogaName;
  final String image;
  final int accuracy;

  PositionAccuracy({
    required this.yogaId,
    required this.yogaName,
    required this.image,
    required this.accuracy,
  });

  factory PositionAccuracy.fromJson(Map<String, dynamic> json) {
    return PositionAccuracy(
      yogaId: json['yogaId'],
      yogaName: json['yogaName'],
      image: json['image'],
      accuracy: json['accuracy'],
    );
  }
}
