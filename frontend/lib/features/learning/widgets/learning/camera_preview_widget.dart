import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';

class CameraPreviewWidget extends ConsumerWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(cameraControllerProvider)
        .when(
          data: (controller) {
            if (controller == null || !controller.value.isInitialized) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }
            return Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CameraPreview(controller),
              ),
            );
          },
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
          error:
              (error, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '카메라를 사용할 수 없습니다: $error',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.invalidate(cameraControllerProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),
        );
  }
}
