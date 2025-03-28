class FeedbackItem {
  final String position;
  final int count;

  FeedbackItem({required this.position, required this.count});

  factory FeedbackItem.fromJson(Map<String, dynamic> json) {
    return FeedbackItem(
      position: json['position'],
      count: json['count'],
    );
  }
}

class RecommendedSequence {
  final int sequenceId;
  final String sequenceName;
  final int sequenceTime;
  final String image;

  RecommendedSequence({
    required this.sequenceId,
    required this.sequenceName,
    required this.sequenceTime,
    required this.image,
  });

  factory RecommendedSequence.fromJson(Map<String, dynamic> json) {
    return RecommendedSequence(
      sequenceId: json['sequence_id'],
      sequenceName: json['sequence_name'],
      sequenceTime: json['sequence_time'],
      image: json['image'],
    );
  }
}

class Pose {
  final String poseName;
  final int accuracy;
  final String image;
  final List<FeedbackItem> feedbackPose;

  Pose({
    required this.poseName,
    required this.accuracy,
    required this.image,
    required this.feedbackPose,
  });

  factory Pose.fromJson(Map<String, dynamic> json) {
    return Pose(
      poseName: json['pose_name'],
      accuracy: json['accuracy'],
      image: json['image'],
      feedbackPose: (json['feedback_pose'] as List)
          .map((item) => FeedbackItem.fromJson(item))
          .toList(),
    );
  }
}

class SequenceReportData {
  final int sequenceId;
  final String sequenceName;
  final int yogaTime;
  final int successCount;
  final int totalAccuracy;
  final List<FeedbackItem> feedbackTotal;
  final String recommendedPosition;
  final List<RecommendedSequence> recommendedSequences;
  final List<Pose> poses;

  SequenceReportData({
    required this.sequenceId,
    required this.sequenceName,
    required this.yogaTime,
    required this.successCount,
    required this.totalAccuracy,
    required this.feedbackTotal,
    required this.recommendedPosition,
    required this.recommendedSequences,
    required this.poses,
  });

  factory SequenceReportData.fromJson(Map<String, dynamic> json) {
    return SequenceReportData(
      sequenceId: json['sequence_id'],
      sequenceName: json['sequence_name'],
      yogaTime: json['yoga_time'],
      successCount: json['success_count'],
      totalAccuracy: json['total_accuracy'],
      feedbackTotal: (json['feedback_total'] as List)
          .map((item) => FeedbackItem.fromJson(item))
          .toList(),
      recommendedPosition: json['recommend_sequence_total']['position'],
      recommendedSequences: (json['recommend_sequence_total']['sequences'] as List)
          .map((item) => RecommendedSequence.fromJson(item))
          .toList(),
      poses: (json['poses'] as List)
          .map((item) => Pose.fromJson(item))
          .toList(),
    );
  }
}
