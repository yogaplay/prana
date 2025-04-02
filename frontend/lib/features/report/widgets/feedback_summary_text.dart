import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class FeedbackSummaryText extends StatelessWidget {
  final List<String> parts;

  const FeedbackSummaryText({super.key, required this.parts});

  @override
  Widget build(BuildContext context) {
    if (parts.isEmpty) {
      return const Text('이번 주는 완벽했어요!', style: TextStyle(fontSize: 16));
    }

    final boldText = parts.join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          boldText,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 6),
        Text('에서 불안정한 자세가 보였습니다.', style: TextStyle(fontSize: 16)),
      ],
    );
  }
}
