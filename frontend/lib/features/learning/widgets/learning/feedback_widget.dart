import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class FeedbackWidget extends StatelessWidget {
  final bool? isSuccess; // null이면 표시 안 함, true면 성공, false면 실패

  const FeedbackWidget({super.key, this.isSuccess});

  @override
  Widget build(BuildContext context) {
    if (isSuccess == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      top: 40,
      left: 40,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSuccess!
                  ? AppColors.primary.withAlpha(180)
                  : Colors.red.withAlpha(180),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSuccess! ? Icons.check : Icons.priority_high,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
