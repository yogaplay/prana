import 'package:frontend/features/search/models/yoga_item.dart';

class BodyFeedback {
  final String position;
  final int count;

  BodyFeedback({required this.position, required this.count});

  factory BodyFeedback.fromJson(Map<String, dynamic> json) {
    return BodyFeedback(position: json['position'], count: json['count']);
  }
}

class WeeklyYogaStat {
  final int year;
  final int month;
  final int week;
  final int time;
  final double accuracy;
  final double bmi;

  WeeklyYogaStat({
    required this.year,
    required this.month,
    required this.week,
    required this.time,
    required this.accuracy,
    required this.bmi,
  });

  factory WeeklyYogaStat.fromJson(Map<String, dynamic> json) {
    return WeeklyYogaStat(
      year: json['year'],
      month: json['month'],
      week: json['week'],
      time: json['time'],
      accuracy: (json['score'] as num).toDouble(),
      bmi: (json['bmi'] as num).toDouble(),
    );
  }
}

class RecommendedSequenceGroup {
  final String position;
  final List<YogaItem> sequences;

  RecommendedSequenceGroup({required this.position, required this.sequences});

  factory RecommendedSequenceGroup.fromJson(Map<String, dynamic> json) {
    return RecommendedSequenceGroup(
      position: json['position'],
      sequences:
          (json['sequences'] as List).map((e) => YogaItem.fromJson(e)).toList(),
    );
  }
}

class WeeklyReport {
  final int year;
  final int month;
  final int week;
  final List<BodyFeedback> feedbacks;
  final List<RecommendedSequenceGroup> recommendSequences;
  final List<WeeklyYogaStat> lastFiveWeeks;

  WeeklyReport({
    required this.year,
    required this.month,
    required this.week,
    required this.feedbacks,
    required this.recommendSequences,
    required this.lastFiveWeeks,
  });

  factory WeeklyReport.fromJson(Map<String, dynamic> json) {
    return WeeklyReport(
      year: json['year'],
      month: json['month'],
      week: json['week'],
      feedbacks:
          (json['feedbacks'] as List)
              .map((e) => BodyFeedback.fromJson(e))
              .toList(),
      recommendSequences:
          (json['recommendSequences'] as List)
              .map((e) => RecommendedSequenceGroup.fromJson(e))
              .toList(),
      lastFiveWeeks:
          [
            json['week5'],
            json['week4'],
            json['week3'],
            json['week2'],
            json['week1'],
          ].map((e) => WeeklyYogaStat.fromJson(e)).toList(),
    );
  }
}
