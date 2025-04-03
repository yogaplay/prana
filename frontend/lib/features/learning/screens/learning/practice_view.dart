import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';
import 'package:frontend/features/learning/widgets/learning/camera_preview_widget.dart';
import 'package:frontend/features/learning/widgets/learning/pose_guide_widget.dart';
import 'package:frontend/features/learning/widgets/learning/timer_widget.dart';

class PracticeView extends ConsumerStatefulWidget {
  const PracticeView({super.key});

  @override
  ConsumerState<PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends ConsumerState<PracticeView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sequence = ref.read(selectedSequenceProvider);
      final currentIndex = ref.read(currentYogaIndexProvider);

      if (sequence != null && currentIndex < sequence.yogaCnt) {
        final duration = sequence.yogaSequence[currentIndex].yogaTime;
        ref.read(countdownProvider.notifier).startCountdown(duration);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.invalidate(cameraControllerProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sequence = ref.watch(selectedSequenceProvider);
    final currentIndex = ref.watch(currentYogaIndexProvider);
    final countdownValue = ref.watch(countdownProvider);

    // 시퀀스가 없으면 로딩 표시
    if (sequence == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    // 타이머가 0이 되면 다음 동작으로 이동
    if (countdownValue == 0 && currentIndex < sequence.yogaSequence.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentIndex = ref.read(currentYogaIndexProvider);
        if (currentIndex < sequence.yogaSequence.length - 1) {
          // 다음 요가 자세로 이동하고 튜토리얼 화면으로 전환
          ref.read(currentYogaIndexProvider.notifier).state = currentIndex + 1;
          ref.read(learningStateProvider.notifier).state =
              LearningState.tutorial;
        } else {
          // 모든 요가 자세 완료 시 완료 상태로 전환
          ref.read(learningStateProvider.notifier).state =
              LearningState.completed;
        }
      });
    }

    return Stack(
      children: [
        // 카메라 미리보기
        const CameraPreviewWidget(),

        // 요가 포즈 가이드 (오른쪽 상단)
        PoseGuideWidget(sequence: sequence, currentIndex: currentIndex),

        // 카운트다운 타이머 (왼쪽 하단)
        TimerWidget(seconds: countdownValue),
      ],
    );
  }
}
