import 'package:flutter/material.dart';
import 'package:frontend/features/report/models/body_feedback.dart';
import 'package:frontend/features/report/models/body_part.dart';
import 'package:frontend/features/report/widgets/pose_feedback_diagram.dart';
import 'package:frontend/features/report/widgets/report_header.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ReportHeader(),
              SizedBox(height: 16),
              PoseFeedbackDiagram(
                bodyFeedback: [
                  BodyFeedback(part: BodyPart.core, count: 3),
                  BodyFeedback(part: BodyPart.leg, count: 5),
                  BodyFeedback(part: BodyPart.arm, count: 1),
                  BodyFeedback(part: BodyPart.shoulder, count: 7),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
