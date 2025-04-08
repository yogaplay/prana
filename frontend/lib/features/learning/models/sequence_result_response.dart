class SequenceResultResponse {
  final int sequenceId;
  final String sequenceName;
  final int yogaTime;
  final int sequenceCnt;
  final int totalAccuracy;
  final String bodyF;
  final String bodyS;
  final List<FeedbackItem> totalFeedback;
  final List<RecommendedSequence> recommendSequenceF;
  final List<RecommendedSequence> recommendSequenceS;
  final List<PositionAccuracy> positionAccuracy;

  SequenceResultResponse({
    required this.sequenceId,
    required this.sequenceName,
    required this.yogaTime,
    required this.sequenceCnt,
    required this.totalAccuracy,
    required this.bodyF,
    required this.bodyS,
    required this.totalFeedback,
    required this.recommendSequenceF,
    required this.recommendSequenceS,
    required this.positionAccuracy,
  });

  factory SequenceResultResponse.fromJson(Map<String, dynamic> json) {
    return SequenceResultResponse(
      sequenceId: json['sequenceId'] ?? 0,
      sequenceName: json['sequenceName'] ?? '',
      yogaTime: json['yogaTime'] ?? 0,
      sequenceCnt: json['sequenceCnt'] ?? 0,
      totalAccuracy: json['totalAccuracy'] ?? 0,
      bodyF: json['bodyF'] ?? '',
      bodyS: json['bodyS'] ?? '',
      totalFeedback:
          ((json['totalFeedback'] as List?) ?? [])
              .map((e) => FeedbackItem.fromJson(e))
              .toList(),
      recommendSequenceF:
          ((json['recommendSequenceF'] as List).map(
            (e) => RecommendedSequence.fromJson(e),
          )).toList(),
      recommendSequenceS:
          ((json['recommendSequenceS'] as List).map(
            (e) => RecommendedSequence.fromJson(e),
          )).toList(),
      positionAccuracy:
          ((json['positionAccuracy'] as List?) ?? [])
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
      position: json['position'] ?? '',
      feedbackCnt: json['feedbackCnt'] ?? 0,
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
      sequenceId: json['sequenceId'] ?? 0,
      sequenceName: json['sequenceName'] ?? '',
      sequenceTime: json['sequenceTime'] ?? 0,
      sequenceImage: json['sequenceImage'] ?? 'https://picsum.photos/100/150',
    );
  }
}

class PoseFeedbackItem {
  final String feedback;
  final int feedbackCnt;

  PoseFeedbackItem({required this.feedback, required this.feedbackCnt});

  factory PoseFeedbackItem.fromJson(Map<String, dynamic> json) {
    return PoseFeedbackItem(
      feedback: json['feedback'] ?? '',
      feedbackCnt: json['feedbackCnt'] ?? 0,
    );
  }
}

class PositionAccuracy {
  final int yogaId;
  final String yogaName;
  final String image;
  final int accuracy;
  final List<PoseFeedbackItem> feedback;

  PositionAccuracy({
    required this.yogaId,
    required this.yogaName,
    required this.image,
    required this.accuracy,
    required this.feedback,
  });

  factory PositionAccuracy.fromJson(Map<String, dynamic> json) {
    return PositionAccuracy(
      yogaId: json['yogaId'] ?? 0,
      yogaName: json['yogaName'] ?? '',
      image: json['image'] ?? 'https://picsum.photos/100',
      accuracy: json['accuracy'] ?? 0,
      feedback:
          ((json['feedback'] as List?) ?? [])
              .map((e) => PoseFeedbackItem.fromJson(e))
              .toList(),
    );
  }
}
