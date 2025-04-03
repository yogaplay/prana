import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/models/sequence_detail_model.dart';

class PoseGuideWidget extends StatelessWidget {
  final SequenceDetailModel sequence;
  final int currentIndex;

  const PoseGuideWidget({
    super.key,
    required this.sequence,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (currentIndex >= sequence.yogaCnt) {
      return const SizedBox.shrink();
    }

    final currentPose = sequence.yogaSequence[currentIndex];

    return Positioned(
      top: 60,
      right: 16,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            currentPose.image,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  width: 150,
                  height: 150,
                  color: AppColors.lightGray,
                  child: const Icon(Icons.image_not_supported),
                ),
          ),
        ),
      ),
    );
  }
}
