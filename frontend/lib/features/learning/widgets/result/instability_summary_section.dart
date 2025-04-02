import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class InstabilitySummarySection extends StatelessWidget {
  final Map<String, int> feedbackCounts;

  const InstabilitySummarySection({super.key, required this.feedbackCounts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '분석 결과',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          ...feedbackCounts.entries.map(
            (entry) => RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: AppColors.blackText),
                children: [
                  TextSpan(
                    text: entry.key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '에서 '),
                  TextSpan(
                    text: '${entry.value}회',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 16, color: AppColors.blackText),
              children: [
                TextSpan(
                  text: '불안정한 자세',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' 가 발견되었습니다!'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
