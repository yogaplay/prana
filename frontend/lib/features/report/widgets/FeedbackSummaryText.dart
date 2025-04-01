import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class FeedbackSummarytext extends StatelessWidget {
  final List<Map<String, dynamic>> feedbacks;

  const FeedbackSummarytext({super.key, required this.feedbacks});

  static const partNameMap = {
    'back': '등',
    'arm': '팔',
    'leg': '다리',
    'core': '코어',
  };

  String buildFeedbackText(List<String> parts) {
    final translated = parts.map((p) => partNameMap[p] ?? p).toList();

    if (translated.isEmpty) return '';
    if (translated.length == 1) return translated[0];

    final commaParts = translated.sublist(0, translated.length - 1).join(', ');
    return '$commaParts, ${translated.last}';
  }

  @override
  Widget build(BuildContext context) {
    final activaParts =
        feedbacks
            .where((f) => f['count']! > 0)
            .map((f) => f['position']! as String)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이번 주의 피드백',
          style: TextStyle(fontSize: 16, color: AppColors.blackText),
        ),
        SizedBox(height: 8),
        activaParts.isNotEmpty
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buildFeedbackText(activaParts),
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.blackText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '에서 불안정한 자세가 보였습니다.',
                  style: TextStyle(fontSize: 16, color: AppColors.blackText),
                ),
              ],
            )
            : Text(
              '이번 주는 완벽했어요!',
              style: TextStyle(fontSize: 16, color: AppColors.blackText),
            ),
      ],
    );
  }
}
