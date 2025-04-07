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

// 피드백 성공 상태를 저장하는 provider
// 피드백 성공 상태를 저장하는 provider (autoDispose를 사용하여 자동 정리)
final feedbackSuccessProvider = StateProvider.autoDispose<bool?>((ref) => null);

class PracticeView extends ConsumerStatefulWidget {
  final int sequenceId;
  const PracticeView({super.key, required this.sequenceId});

  @override
  ConsumerState<PracticeView> createState() => _PracticeViewState();
}

class _PracticeViewState extends ConsumerState<PracticeView>
    with WidgetsBindingObserver {
  late FeedbackManager _feedbackManager;
  // dispose 직전에 상태를 저장하기 위한 플래그
  bool _isDisposing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // FeedbackManager에 콜백 대신 Provider를 통해 상태 업데이트
    _feedbackManager = FeedbackManager(ref, (isSuccess) {
      if (mounted) {
        ref.read(feedbackSuccessProvider.notifier).state = isSuccess;
      }
    });

    final currentIndex = ref.read(currentYogaIndexProvider);
    print('연습 시작: 요가 동작 인덱스 $currentIndex');
    Future.microtask(() => _initializeYogaSession());
  }

  @override
  void dispose() {
    print('PracticeView dispose 시작');

    // 먼저 처리 중 플래그를 설정하여 다른 비동기 작업이 실행되지 않도록 합니다
    _isDisposing = true;

    // 피드백 매니저 먼저 정리
    _feedbackManager.dispose();

    // 위젯 바인딩 옵저버 제거
    WidgetsBinding.instance.removeObserver(this);

    print('PracticeView dispose 완료');
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('앱 생명주기 변경: $state');

    if (_isDisposing) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // 앱이 백그라운드로 갈 때 타이머만 정리
      _feedbackManager.pauseFeedback();

      // didChangeAppLifecycleState에서 카메라 초기화
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isDisposing) {
          // 여기서 카메라 컨트롤러 제공자를 대신해서 직접 카메라를 정리하는 코드로 대체할 수 있음
          // 예: _cameraController?.dispose();
        }
      });
    } else if (state == AppLifecycleState.resumed) {
      // 앱이 다시 포그라운드로 왔을 때
      if (mounted && !_isDisposing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isDisposing) {
            _feedbackManager.resumeFeedback();
          }
        });
      }
    }
  }

  // 요가 세션 초기화
  Future<void> _initializeYogaSession() async {
    try {
      if (_isDisposing || !mounted) return;

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
        if (mounted && !_isDisposing) {
          ref.read(userSequenceIdProvider.notifier).state = userSequenceId;
        }

        // 시퀀스 정보 로드
        await ref.read(sequenceDetailProvider(widget.sequenceId).future);
        print('시퀀스 정보 로드 완료');
      }

      if (!mounted || _isDisposing) return;

      // 현재 요가 동작의 타이머 시작
      final sequence = ref.read(selectedSequenceProvider);
      if (sequence != null && sequence.yogaSequence.isNotEmpty) {
        final yogaTime = sequence.yogaSequence[currentIndex].yogaTime;
        print('요가 동작 $currentIndex 시간: $yogaTime초');

        // 타이머 시작 전 로그
        print('타이머 시작 시도');
        if (mounted && !_isDisposing) {
          ref.read(countdownProvider.notifier).startCountdown(yogaTime);
          print('타이머 시작 완료');
        }

        // 첫 요가 포즈 저장은 첫 번째 동작에서만
        if (currentIndex == 0) {
          final userSequenceId = ref.read(userSequenceIdProvider);
          if (userSequenceId != null && mounted && !_isDisposing) {
            final learningService = ref.read(learningServiceProvider);
            await learningService.saveYogaPose(userSequenceId);
          }
        }

        // 피드백 타이머 시작
        if (mounted && !_isDisposing) {
          _feedbackManager.startFeedback();
          print('피드백 타이머 시작 완료');
        }
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
    // _isDisposing 상태일 때는 최소한의 UI만 반환
    if (_isDisposing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final sequence = ref.watch(selectedSequenceProvider);
    final currentIndex = ref.watch(currentYogaIndexProvider);
    final isCompleted = ref.watch(isSequenceCompletedProvider);
    final isSuccessfulPose = ref.watch(feedbackSuccessProvider);

    // 시퀀스 완료
    if (isCompleted && !_isDisposing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_isDisposing) {
          _cancelTimers();
        }
      });
    }

    // 로딩 화면
    if (sequence == null) {
      return _buildLoadingScreen();
    }

    // 연습 화면
    return _buildPracticeScreen(sequence, currentIndex, isSuccessfulPose);
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
  Widget _buildPracticeScreen(
    dynamic sequence,
    int currentIndex,
    bool? isSuccessfulPose,
  ) {
    return Scaffold(
      body: Stack(
        children: [
          // 카메라 미리보기
          const CameraPreviewWidget(),

          // 요가 포즈 가이드 (오른쪽 상단)
          PoseGuideWidget(sequence: sequence, currentIndex: currentIndex),

          // 오른쪽 하단 타이머
          const TimerWidget(),

          // 왼쪽 상단 피드백
          FeedbackWidget(isSuccess: isSuccessfulPose),
        ],
      ),
    );
  }
}
