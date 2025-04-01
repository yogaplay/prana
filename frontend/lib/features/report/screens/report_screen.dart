import 'package:flutter/material.dart';
import 'package:frontend/features/report/models/body_feedback.dart';
import 'package:frontend/features/report/models/body_part.dart';
import 'package:frontend/features/report/models/weekly_yoga_data.dart';
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

    final partCounts = {
      "left_shoulder": 3,
      "right_shoulder": 3,
      "elbow_left": 1,
      "elbow_right": 1,
      "arm_left": 1,
      "arm_right": 2,
      "hip_left": 1,
      "hip_right": 1,
      "knee_left": 2,
      "knee_right": 1,
      "leg_left": 1,
      "leg_right": 1,
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
              PoseFeedbackDiagram(isMale: true, partCounts: partCounts),
              SizedBox(height: 16),
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
