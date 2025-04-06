import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';
import 'package:frontend/features/learning/services/feedback_service.dart';
import 'package:frontend/features/learning/widgets/learning/camera_preview_widget.dart';
import 'package:frontend/features/learning/widgets/learning/feedback_widget.dart';
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
  late FeedbackManager _feedbackManager;
  bool? _isSuccessfulPose;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _feedbackManager = FeedbackManager(ref, (isSuccess) {
      setState(() {
        _isSuccessfulPose = isSuccess;
      });
    });

    final currentIndex = ref.read(currentYogaIndexProvider);
    print('연습 시작: 요가 동작 인덱스 $currentIndex');
    Future.microtask(() => _initializeYogaSession());
  }

  @override
  void dispose() {
    print('PracticeView dispose 시작');

    _feedbackManager.dispose();

    // 카메라 관련 Provider 상태 초기화
    Future.microtask(() {
      if (mounted) {
        ref.invalidate(cameraControllerProvider);
      }
    });

    WidgetsBinding.instance.removeObserver(this);
    print('PracticeView dispose 완료');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('앱 생명주기 변경: $state');

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 갈 때 타이머 및 카메라 정리
      _feedbackManager.pauseFeedback();
      ref.invalidate(cameraControllerProvider);
    } else if (state == AppLifecycleState.resumed) {
      // 앱이 다시 포그라운드로 왔을 때
      if (mounted) {
        Future.microtask(() {
          _feedbackManager.resumeFeedback();
        });
      }
    }
  }

  // 요가 세션 초기화
  Future<void> _initializeYogaSession() async {
    try {
      final currentIndex = ref.read(currentYogaIndexProvider);

      // 여기에서 첫 번째 동작인 경우에만 요가 세션 시작 API 호출
      if (currentIndex == 0) {
        // 요가 시작
        final learningService = ref.read(learningServiceProvider);
        final userSequenceId = await learningService.startYoga(
          widget.sequenceId,
        );
        print('유저 시퀀스 ID: $userSequenceId');

        // 사용자 시퀀스 ID 저장
        ref.read(userSequenceIdProvider.notifier).state = userSequenceId;

        // 시퀀스 정보 로드
        await ref.read(sequenceDetailProvider(widget.sequenceId).future);
        print('시퀀스 정보 로드 완료');
      }

      // 현재 요가 동작의 타이머 시작
      final sequence = ref.read(selectedSequenceProvider);
      if (sequence != null && sequence.yogaSequence.isNotEmpty) {
        final yogaTime = sequence.yogaSequence[currentIndex].yogaTime;
        print('요가 동작 $currentIndex 시간: $yogaTime초');

        // 타이머 시작 전 로그
        print('타이머 시작 시도');
        ref.read(countdownProvider.notifier).startCountdown(yogaTime);
        print('타이머 시작 완료');

        // 첫 요가 포즈 저장은 첫 번째 동작에서만
        if (currentIndex == 0) {
          final userSequenceId = ref.read(userSequenceIdProvider);
          if (userSequenceId != null) {
            final learningService = ref.read(learningServiceProvider);
            await learningService.saveYogaPose(userSequenceId);
          }
        }

        // 피드백 타이머 시작
        _feedbackManager.startFeedback();
        print('피드백 타이머 시작 완료');
      } else {
        print('시퀀스 정보가 없거나 요가 시퀀스가 비어 있습니다.');
      }
    } catch (e) {
      print('요가 세션 초기화 오류: $e');
    }
  }

  void _cancelTimers() {
    _feedbackManager.pauseFeedback();
  }

  @override
  Widget build(BuildContext context) {
    final sequence = ref.watch(selectedSequenceProvider);
    final currentIndex = ref.watch(currentYogaIndexProvider);
    final isCompleted = ref.watch(isSequenceCompletedProvider);

    // 시퀀스 완료
    if (isCompleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _cancelTimers();
      });
    }
    // 로딩 화면
    if (sequence == null) {
      return _buildLoadingScreen();
    }

    // 연습 화면
    return _buildPracticeScreen(sequence, currentIndex);
  }

  // 로딩 화면
  Widget _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          backgroundColor: Colors.black,
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
          PoseGuideWidget(sequence: sequence, currentIndex: currentIndex),

          const TimerWidget(),

          Positioned(
            top: 20,
            left: 20,
            child: FeedbackWidget(isSuccess: _isSuccessfulPose),
          ),
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
