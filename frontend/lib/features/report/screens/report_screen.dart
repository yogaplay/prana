import 'package:flutter/material.dart';
import 'package:frontend/features/report/models/weekly_yoga_data.dart';
import 'package:frontend/features/report/widgets/feedback_summary_text.dart';
import 'package:frontend/features/report/widgets/pose_feedback_diagram.dart';
import 'package:frontend/features/report/widgets/report_header.dart';
import 'package:frontend/features/report/widgets/yoga_accuracy_chart.dart';
import 'package:frontend/features/report/widgets/yoga_bmi_chart.dart';
import 'package:frontend/features/report/widgets/yoga_time_chart.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyData = [
      WeeklyYogaData(
        year: 2025,
        month: 2,
        week: 2,
        time: 72,
        accurary: 78,
        bmi: 21,
      ),
      WeeklyYogaData(
        year: 2025,
        month: 2,
        week: 3,
        time: 88,
        accurary: 82,
        bmi: 20,
      ),
      WeeklyYogaData(
        year: 2025,
        month: 2,
        week: 4,
        time: 95,
        accurary: 85,
        bmi: 20,
      ),
      WeeklyYogaData(
        year: 2025,
        month: 3,
        week: 1,
        time: 100,
        accurary: 90,
        bmi: 20,
      ),
      WeeklyYogaData(
        year: 2025,
        month: 3,
        week: 2,
        time: 90,
        accurary: 87,
        bmi: 20,
      ),
    ];

    final List<BodyFeedback> dummyFeedbacks = [
      BodyFeedback(part: BodyPart.back, count: 3),
      BodyFeedback(part: BodyPart.arm, count: 1),
      BodyFeedback(part: BodyPart.core, count: 4),
      BodyFeedback(part: BodyPart.leg, count: 2),
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ReportHeader(),
              SizedBox(height: 16),
              Text('이번 주의 피드백', style: TextStyle(fontSize: 16)),
              SizedBox(height: 8),
              FeedbackSummaryText(parts: ['등', '팔', '다리']),
              SizedBox(height: 16),
              PoseFeedbackDiagram(isMale: true, feedbacks: dummyFeedbacks),
              SizedBox(height: 16),
              YogaTimeChart(data: dummyData),
              SizedBox(height: 16),
              YogaAccuracyChart(data: dummyData),
              SizedBox(height: 16),
              YogaBmiChart(data: dummyData),
            ],
          ),
        ),
      ),
    );
  }
}
