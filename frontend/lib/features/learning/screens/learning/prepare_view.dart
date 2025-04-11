import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';
import 'package:frontend/features/learning/widgets/learning/camera_preview_widget.dart';
import 'package:frontend/features/learning/widgets/learning/pose_guide_widget.dart';
import 'package:frontend/features/learning/services/feedback_service.dart'; // FeedbackManager 포함된 파일

class PrepareView extends ConsumerStatefulWidget {
  final int sequenceId;

  const PrepareView({Key? key, required this.sequenceId}) : super(key: key);

  @override
  ConsumerState<PrepareView> createState() => _PrepareViewState();
}

class _PrepareViewState extends ConsumerState<PrepareView> {
  Timer? _timer;
  late FeedbackManager _feedbackManager;

  @override
  void initState() {
    super.initState();
    _feedbackManager = FeedbackManager(ref, null);

    // selectedSequenceProvider로부터 시퀀스 정보를 읽어 현재 동작의 yogaName을 가져옴
    final sequence = ref.read(selectedSequenceProvider);
    final currentIndex = ref.read(currentYogaIndexProvider);
    if (sequence != null && sequence.yogaSequence.isNotEmpty && currentIndex < sequence.yogaSequence.length) {
      final String poseName = sequence.yogaSequence[currentIndex].yogaName;
      _feedbackManager.speakYogaPose(poseName);
    }

    // 카운트다운 시작
    _startCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _feedbackManager.dispose();
    super.dispose();
  }

  void _startCountdown() {
    // 카운트다운 초기화 (예: 5초)
    ref.read(prepareCountdownProvider.notifier).state = 5;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentCount = ref.read(prepareCountdownProvider);

      if (currentCount <= 1) {
        timer.cancel();
        // 카운트다운 종료 후 학습 상태를 practice으로 변경
        ref.read(learningStateProvider.notifier).state = LearningState.practice;
      } else {
        ref.read(prepareCountdownProvider.notifier).state = currentCount - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final countdown = ref.watch(prepareCountdownProvider);
    final sequence = ref.watch(selectedSequenceProvider);
    final currentIndex = ref.watch(currentYogaIndexProvider);

    return Scaffold(
      body: Stack(
        children: [
          // 카메라 미리보기
          const CameraPreviewWidget(),

          // 요가 포즈 가이드 (오른쪽 상단)
          if (sequence != null)
            PoseGuideWidget(sequence: sequence, currentIndex: currentIndex),

          // 준비 단계 오버레이
          Container(
            color: Colors.black.withOpacity(0.6),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '자세를 준비하세요',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$countdown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
