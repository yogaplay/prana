import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/widgets/learning/camera_preview_widget.dart';
import 'package:frontend/features/learning/widgets/learning/pose_guide_widget.dart';
import 'package:frontend/features/learning/widgets/learning/timer_widget.dart';

/// 연습 화면 로딩 상태
class PracticeLoadingScreen extends StatelessWidget {
  const PracticeLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.blackText,
        ),
      ),
    );
  }
}

/// 메인 연습 화면
class PracticeMainScreen extends StatelessWidget {
  final dynamic sequence;
  final int currentIndex;

  const PracticeMainScreen({
    super.key,
    required this.sequence,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 카메라 미리보기
          const CameraPreviewWidget(),

          // 요가 포즈 가이드 (오른쪽 상단)
          PoseGuideWidget(sequence: sequence, currentIndex: currentIndex),

          // 타이머 위젯
          const TimerWidget(),
        ],
      ),
    );
  }
}
