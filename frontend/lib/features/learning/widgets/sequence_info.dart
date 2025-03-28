import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class SequenceInfo extends StatelessWidget {
  final String title;
  final String duration;
  final String poseCount;
  final String description;

  const SequenceInfo({
    super.key,
    required this.title,
    required this.duration,
    required this.poseCount,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackText,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.star, color: AppColors.primary, size: 32),
              onPressed: () {
                // Toggle favorite status
              },
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text(
              duration,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.graytext,
              ),
            ),
            const Text(
              ' | ',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.graytext,
              ),
            ),
            Text(
              poseCount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.graytext,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: AppColors.blackText),
        ),
      ],
    );
  }
}
