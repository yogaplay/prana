import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';
import 'package:frontend/features/learning/widgets/learning/camera_preview_widget.dart';
import 'package:frontend/features/learning/widgets/learning/pose_guide_widget.dart';
import 'package:frontend/features/learning/widgets/learning/timer_widget.dart';

class PracticeView extends ConsumerStatefulWidget {
  final int sequenceId;
  const PracticeView({super.key, required this.sequenceId});

  @override
  ConsumerState<PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends ConsumerState<PracticeView>
    with WidgetsBindingObserver {
  Timer? _shortFeedbackTimer;
  Timer? _longFeedbackTimer;
  String _poseFeedback = "";
  String _poseStatus = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initializeYogaSession();
  }

  Future<void> _initializeYogaSession() async {
    try {
      print('~~요가 세션 초기화~~');

      // 요가 시작
      final learningService = ref.read(learningServiceProvider);
      final userSequenceId = await learningService.startYoga(widget.sequenceId);
      print('유저 시퀀스 ID: $userSequenceId');

      // 사용자 시퀀스 ID 저장
      ref.read(userSequenceIdProvider.notifier).state = userSequenceId;

      // 시퀀스 정보 로드
      await ref.read(sequenceDetailProvider(widget.sequenceId).future);
      print('시퀀스 정보 로드 완료');

      // 첫 번째 요가 동작의 타이머 시작
      final sequence = ref.read(selectedSequenceProvider);
      if (sequence != null && sequence.yogaSequence.isNotEmpty) {
        final firstYogaTime = sequence.yogaSequence[0].yogaTime;
        print('첫 번째 요가 시간: $firstYogaTime초');

        // 타이머 시작 전 로그
        print('타이머 시작 시도');
        ref.read(countdownProvider.notifier).startCountdown(firstYogaTime);
        print('타이머 시작 완료');

        // 첫 요가 포즈 저장
        await learningService.saveYogaPose(userSequenceId);

        // 피드백 타이머 시작
        _startFeedbackTimers();
        print('피드백 타이머 시작 완료');
      } else {
        print('시퀀스 정보가 없거나 요가 시퀀스가 비어 있습니다.');
      }
    } catch (e) {
      print('요가 세션 초기화 오류: $e');
    }
  }

  void _startFeedbackTimers() {
    _shortFeedbackTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _getShortFeedback(),
    );

    _longFeedbackTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _getLongFeedback(),
    );
  }

  Future<void> _getShortFeedback() async {
    try {
      final learningService = ref.read(learningServiceProvider);
      final userSequenceId = ref.read(userSequenceIdProvider);
      final sequence = ref.read(selectedSequenceProvider);
      final currentIndex = ref.read(currentYogaIndexProvider);

      if (userSequenceId == null || sequence == null) return;
      if (currentIndex >= sequence.yogaSequence.length) return;

      final yogaId = sequence.yogaSequence[currentIndex].yogaId;

      final imageFile = await _captureImage();
      if (imageFile == null) return;

      final status = await learningService.sendShortFeedback(
        yogaId: yogaId,
        userSequenceId: userSequenceId,
        imageFile: imageFile,
      );

      setState(() {
        _poseStatus = status;
      });
    } catch (e) {
      print('에러 발생!! Short Feedback ERROR: $e');
    }
  }

  Future<void> _getLongFeedback() async {
    try {
      final learningService = ref.read(learningServiceProvider);
      final userSequenceId = ref.read(userSequenceIdProvider);
      final sequence = ref.read(selectedSequenceProvider);
      final currentIndex = ref.read(currentYogaIndexProvider);

      if (userSequenceId == null || sequence == null) return;
      if (currentIndex >= sequence.yogaSequence.length) return;

      final yogaId = sequence.yogaSequence[currentIndex].yogaId;

      final imageFile = await _captureImage();
      if (imageFile == null) return;

      final feedback = await learningService.sendLongFeedback(
        yogaId: yogaId,
        userSequenceId: userSequenceId,
        imageFile: imageFile,
      );

      if (feedback.isNotEmpty) {
        setState(() {
          _poseFeedback = feedback;
        });
      }
    } catch (e) {
      print('에러 발생!! Long Feedback ERROR: $e');
    }
  }

  // 이미지 캡처
  Future<File?> _captureImage() async {
    try {
      final captureFunction = ref.read(captureImageProvider);
      return await captureFunction();
    } catch (e) {
      print('카메라 캡처 오류: $e');
      return null;
    }
  }

  // 현재 요가가 끝날 때 정확도 저장
  Future<void> _saveYogaAccuracy() async {
    try {
      final learningService = ref.read(learningServiceProvider);
      final userSequenceId = ref.read(userSequenceIdProvider);
      final sequence = ref.read(selectedSequenceProvider);
      final currentIndex = ref.read(currentYogaIndexProvider);

      if (userSequenceId == null || sequence == null) return;
      if (currentIndex >= sequence.yogaSequence.length) return;

      final yogaId = sequence.yogaSequence[currentIndex].yogaId;

      await learningService.saveAccuracyComplete(
        userSequenceId: userSequenceId,
        yogaId: yogaId,
        sequenceId: widget.sequenceId,
      );
    } catch (e) {
      print('자세 정확도 저장 오류: $e');
    }
  }

  @override
  void dispose() {
    _shortFeedbackTimer?.cancel();
    _longFeedbackTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 갈 때 피드백 타이머 정지
      _shortFeedbackTimer?.cancel();
      _longFeedbackTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      // 앱이 다시 포그라운드로 왔을 때 피드백 타이머 재개
      _startFeedbackTimers();
      ref.invalidate(cameraControllerProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sequence = ref.watch(selectedSequenceProvider);
    final currentIndex = ref.watch(currentYogaIndexProvider);
    final isCompleted = ref.watch(isSequenceCompletedProvider);

    // 시퀀스가 없으면 로딩 표시
    if (sequence == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    // 시퀀스가 완료되었으면 완료 화면 표시
    if (isCompleted) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 80,
              ),
              const SizedBox(height: 16),
              const Text(
                '요가 시퀀스 완료!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                child: const Text('완료', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          // 카메라 미리보기
          const CameraPreviewWidget(),

          // 요가 포즈 가이드 (오른쪽 상단)
          PoseGuideWidget(sequence: sequence, currentIndex: currentIndex),

          // 카운트다운 타이머 (왼쪽 하단)
          const TimerWidget(),

          // 피드백 표시 (상단)
          if (_poseFeedback.isNotEmpty)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _poseFeedback,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // 성공/실패 상태 표시 (하단)
          if (_poseStatus.isNotEmpty)
            Positioned(
              bottom: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color:
                        _poseStatus == 'success'
                            ? Colors.green.withOpacity(0.7)
                            : Colors.red.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _poseStatus == 'success' ? '자세 정확함' : '자세 교정 필요',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
