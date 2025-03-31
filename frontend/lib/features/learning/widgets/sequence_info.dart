import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/providers.dart';

class SequenceInfo extends ConsumerWidget {
  final String title;
  final String duration;
  final String poseCount;
  final String description;
  final int sequenceId;
  const SequenceInfo({
    super.key,
    required this.title,
    required this.duration,
    required this.poseCount,
    required this.description,
    required this.sequenceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteState = ref.watch(sequenceFavoriteProvider(sequenceId));
    print('즐겨찾기 상태: $favoriteState');
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
            favoriteState.when(
              data:
                  (isFavorite) => IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color:
                          isFavorite ? AppColors.primary : AppColors.graytext,
                      size: 32,
                    ),
                    onPressed: () {
                      ref
                          .read(sequenceFavoriteProvider(sequenceId).notifier)
                          .toggleFavorite();
                    },
                  ),
              loading:
                  () => const SizedBox(
                    width: 32,
                    height: 32,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
              error:
                  (_, __) => IconButton(
                    icon: const Icon(
                      Icons.star_border,
                      color: AppColors.graytext,
                      size: 32,
                    ),
                    onPressed: () {
                      ref
                          .read(sequenceFavoriteProvider(sequenceId).notifier)
                          .toggleFavorite();
                    },
                  ),
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
