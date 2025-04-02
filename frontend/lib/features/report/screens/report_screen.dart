import 'package:flutter/material.dart';
import 'package:frontend/features/report/models/weekly_yoga_data.dart';
import 'package:frontend/features/report/widgets/feedback_summary_text.dart';
import 'package:frontend/features/report/widgets/pose_feedback_diagram.dart';
import 'package:frontend/features/report/widgets/recommended_yoga_section.dart';
import 'package:frontend/features/report/widgets/report_header.dart';
import 'package:frontend/features/report/widgets/yoga_accuracy_chart.dart';
import 'package:frontend/features/report/widgets/yoga_bmi_chart.dart';
import 'package:frontend/features/report/widgets/yoga_time_chart.dart';
import 'package:frontend/features/search/models/yoga_item.dart';

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

    final Map<String, List<YogaItem>> dummyRecommendedItems = {
      '등': [
        YogaItem(
          id: 0,
          title: '등을 위한 요가 1',
          imageUrl: 'https://picsum.photos/id/1011/200/120',
          duration: '30분',
        ),
        YogaItem(
          id: 1,
          title: '등을 위한 요가 2',
          imageUrl: 'https://picsum.photos/id/1012/200/120',
          duration: '30분',
        ),
        YogaItem(
          id: 2,
          title: '등을 위한 요가 3',
          imageUrl: 'https://picsum.photos/id/1013/200/120',
          duration: '20분',
        ),
      ],
      '다리': [
        YogaItem(
          id: 0,
          title: '다리를 위한 요가 1',
          imageUrl: 'https://picsum.photos/id/1021/200/120',
          duration: '25분',
        ),
        YogaItem(
          id: 1,
          title: '다리를 위한 요가 2',
          imageUrl: 'https://picsum.photos/id/1022/200/120',
          duration: '30분',
        ),
        YogaItem(
          id: 2,
          title: '다리를 위한 요가 3',
          imageUrl: 'https://picsum.photos/id/1023/200/120',
          duration: '30분',
        ),
      ],
    };

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
              RecommendedYogaSection(recommendedItems: dummyRecommendedItems),
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
