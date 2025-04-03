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
  // 상태 변수
  Timer? _shortFeedbackTimer;
  Timer? _longFeedbackTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeYogaSession();
  }

  @override
  void dispose() {
    _cancelTimers();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _cancelTimers() {
    _shortFeedbackTimer?.cancel();
    _longFeedbackTimer?.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _cancelTimers();
    } else if (state == AppLifecycleState.resumed) {
      _startFeedbackTimers();
      ref.invalidate(cameraControllerProvider);
    }
  }

  // 요가 세션 초기화
  Future<void> _initializeYogaSession() async {
    try {
      print('~~요가 세션 초기화~~');

      // 요가 시작
      final learningService = ref.read(learningServiceProvider);
      final userSequenceId = await learningService.startYoga(widget.sequenceId);
      print('유저 시퀀스 ID: $userSequenceId');

      // 사용자 시퀀스 ID 저장
      ref.read(userSequenceIdProvider.notifier).state = userSequenceId;

      // 시퀀스 정보 로드 및 타이머 시작
      await _loadSequenceAndStartTimer(userSequenceId, learningService);
    } catch (e) {
      print('요가 세션 초기화 오류: $e');
    }
  }

  // 시퀀스 정보 로드 및 타이머 시작 로직 분리
  Future<void> _loadSequenceAndStartTimer(
    int userSequenceId,
    dynamic learningService,
  ) async {
    await ref.read(sequenceDetailProvider(widget.sequenceId).future);
    print('시퀀스 정보 로드 완료');

    final sequence = ref.read(selectedSequenceProvider);
    if (sequence != null && sequence.yogaSequence.isNotEmpty) {
      final firstYogaTime = sequence.yogaSequence[0].yogaTime;
      print('첫 번째 요가 시간: $firstYogaTime초');

      // 타이머 시작
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
  }

  // 피드백 타이머 시작
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

  // 짧은 피드백 가져오기
  Future<void> _getShortFeedback() async {
    try {
      final feedbackData = _getFeedbackData();
      if (feedbackData == null) return;

      final imageFile = await _captureImage();
      if (imageFile == null) return;

      final status = await feedbackData.learningService.sendShortFeedback(
        yogaId: feedbackData.yogaId,
        userSequenceId: feedbackData.userSequenceId,
        imageFile: imageFile,
      );
    } catch (e) {
      print('에러 발생!! Short Feedback ERROR: $e');
    }
  }

  // 긴 피드백 가져오기
  Future<void> _getLongFeedback() async {
    try {
      final feedbackData = _getFeedbackData();
      if (feedbackData == null) return;

      final imageFile = await _captureImage();
      if (imageFile == null) return;

      final feedback = await feedbackData.learningService.sendLongFeedback(
        yogaId: feedbackData.yogaId,
        userSequenceId: feedbackData.userSequenceId,
        imageFile: imageFile,
      );

      if (feedback.isNotEmpty) {
        print("피드백: $feedback");
      }
    } catch (e) {
      print('에러 발생!! Long Feedback ERROR: $e');
    }
  }

  // 피드백 데이터 가져오기 로직 분리
  _FeedbackData? _getFeedbackData() {
    final learningService = ref.read(learningServiceProvider);
    final userSequenceId = ref.read(userSequenceIdProvider);
    final sequence = ref.read(selectedSequenceProvider);
    final currentIndex = ref.read(currentYogaIndexProvider);

    if (userSequenceId == null || sequence == null) return null;
    if (currentIndex >= sequence.yogaSequence.length) return null;

    final yogaId = sequence.yogaSequence[currentIndex].yogaId;

    return _FeedbackData(
      learningService: learningService,
      userSequenceId: userSequenceId,
      yogaId: yogaId,
    );
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

  @override
  Widget build(BuildContext context) {
    final sequence = ref.watch(selectedSequenceProvider);
    final currentIndex = ref.watch(currentYogaIndexProvider);
    final isCompleted = ref.watch(isSequenceCompletedProvider);

    // 로딩 화면
    if (sequence == null) {
      return _buildLoadingScreen();
    }

    // 완료 화면
    if (isCompleted) {
      return _buildCompletionScreen();
    }

    // 연습 화면
    return _buildPracticeScreen(sequence, currentIndex);
  }

  // 로딩 화면
  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );
  }

  // 완료 화면
  Widget _buildCompletionScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: AppColors.primary, size: 80),
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

  // 연습 화면
  Widget _buildPracticeScreen(dynamic sequence, int currentIndex) {
    return Scaffold(
      body: Stack(
        children: [
          // 카메라 미리보기
          const CameraPreviewWidget(),

          // 요가 포즈 가이드 (오른쪽 상단)
          PoseGuideWidget(
            sequence: sequence,
            currentIndex: currentIndex,
            // UI 수정: 이미지 크기 축소 및 radius 줄임
          ),

          const TimerWidget(),
        ],
      ),
    );
  }
}

// 피드백 데이터를 담는 클래스
class _FeedbackData {
  final dynamic learningService;
  final int userSequenceId;
  final int yogaId;

  _FeedbackData({
    required this.learningService,
    required this.userSequenceId,
    required this.yogaId,
  });
}
