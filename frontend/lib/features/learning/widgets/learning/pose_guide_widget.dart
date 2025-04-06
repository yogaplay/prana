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
      top: 20,
      right: 20,
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(3),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            currentPose.image,
            width: 130,
            height: 130,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  width: 130,
                  height: 120,
                  color: AppColors.lightGray,
                  child: const Icon(Icons.image_not_supported),
                ),
          ),
        ),
      ),
    );
  }
}
