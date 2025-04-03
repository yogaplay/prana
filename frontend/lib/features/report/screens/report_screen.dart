import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/report/models/weekly_yoga_data.dart';
import 'package:frontend/features/report/providers/weekly_report_provider.dart';
import 'package:frontend/features/report/widgets/feedback_summary_text.dart';
import 'package:frontend/features/report/widgets/pose_feedback_diagram.dart';
import 'package:frontend/features/report/widgets/recommended_yoga_section.dart';
import 'package:frontend/features/report/widgets/report_header.dart';
import 'package:frontend/features/report/widgets/yoga_accuracy_chart.dart';
import 'package:frontend/features/report/widgets/yoga_bmi_chart.dart';
import 'package:frontend/features/report/widgets/yoga_time_chart.dart';

class ReportScreen extends ConsumerWidget {
  final String date;

  const ReportScreen({super.key, required this.date});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(date);
    final reportAsync = ref.watch(weeklyReportProvider(date));

    return Scaffold(
      body: SafeArea(
        child: reportAsync.when(
          data: (report) {
            final feedbackParts =
                report.feedbacks
                    .where((f) => f.count > 0)
                    .map((f) => _mapToKor(f.position))
                    .toList();
            final feedbackWidgets =
                report.feedbacks
                    .map(
                      (f) => BodyFeedback(
                        part: _mapToBodyPartEnum(f.position),
                        count: f.count,
                      ),
                    )
                    .toList();
            final recommendedMap = {
              for (var group in report.recommendSequences)
                group.position: group.sequences,
            };
            final chartData =
                report.lastFiveWeeks
                    .map(
                      (e) => WeeklyYogaData(
                        year: e.year,
                        month: e.month,
                        week: e.week,
                        time: e.time,
                        accurary: e.accuracy,
                        bmi: e.bmi,
                      ),
                    )
                    .toList();

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ReportHeader(
                    year: report.year,
                    month: report.month,
                    week: report.week,
                  ),
                  SizedBox(height: 16),
                  Text('이번 주의 피드백', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  FeedbackSummaryText(parts: feedbackParts),
                  SizedBox(height: 16),
                  PoseFeedbackDiagram(isMale: true, feedbacks: feedbackWidgets),
                  SizedBox(height: 16),
                  RecommendedYogaSection(recommendedItems: recommendedMap),
                  SizedBox(height: 16),
                  YogaTimeChart(data: chartData),
                  SizedBox(height: 32),
                  YogaAccuracyChart(data: chartData),
                  SizedBox(height: 32),
                  YogaBmiChart(data: chartData),
                ],
              ),
            );
          },
          error: (err, stack) => Center(child: Text('에러 발생: $err')),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  String _mapToKor(String key) {
    switch (key) {
      case 'back':
        return '등';
      case 'arm':
        return '팔';
      case 'core':
        return '코어';
      case 'leg':
        return '다리';
      default:
        return key;
    }
  }

  BodyPart _mapToBodyPartEnum(String key) {
    switch (key) {
      case 'back':
        return BodyPart.back;
      case 'arm':
        return BodyPart.arm;
      case 'core':
        return BodyPart.core;
      case 'leg':
        return BodyPart.leg;
      default:
        throw Exception('Unknown body part: $key');
    }
  }
}
