import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/models/pose_result.dart';
import 'package:frontend/features/learning/widgets/result/pose_result_card.dart';

class PoseResultSummarySection extends StatelessWidget {
  final List<PoseResult> results;

  const PoseResultSummarySection({super.key, required this.results});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '자세별 분석 결과',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          ...results.map((result) => PoseResultCard(result: result)),
        ],
      ),
    );
  }
}
