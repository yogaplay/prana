import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/learning/models/sequence_detail_model.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';
import 'package:frontend/features/learning/services/learning_service.dart';

final learningServiceProvider = Provider<LearningService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return LearningService(apiClient);
});

// 유저 시퀀스 ID 관리
final userSequenceIdProvider = StateProvider<int?>((ref) => null);

enum LearningState { initial, tutorial, practice, completed }

// 현재 학습 상태 관리
final learningStateProvider = StateProvider<LearningState>((ref) {
  return LearningState.initial;
});

// 모든 튜토리얼 스킵 여부
final skipAllTutorialsProvider = StateProvider<bool>((ref) {
  return false;
});

// 화면 방향 제어
final orientationProvider = StateProvider<List<DeviceOrientation>>((ref) {
  return [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown];
});

// 현재 요가 인덱스 관리
final currentYogaIndexProvider = StateProvider<int>((ref) => 0);

final currentYogaProvider = Provider<YogaModel?>((ref) {
  final sequenceDetail = ref.watch(selectedSequenceProvider);
  final currentIndex = ref.watch(currentYogaIndexProvider);

  if (sequenceDetail == null ||
      sequenceDetail.yogaSequence.isEmpty ||
      currentIndex >= sequenceDetail.yogaSequence.length) {
    return null;
  }
  return sequenceDetail.yogaSequence[currentIndex];
});

// 사용 가능한 카메라 목록을 저장
final camerasProvider = FutureProvider<List<CameraDescription>>((ref) async {
  return await availableCameras();
});

final cameraControllerProvider = FutureProvider.autoDispose<CameraController?>((
  ref,
) async {
  try {
    // 사용 가능한 카메라 가져오기
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw Exception('사용 가능한 카메라가 없습니다');
    }

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    final controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // 초기화 전에 Provider가 dispose되었는지 확인
    if (ref.state is AsyncLoading) {
      await controller.initialize();
    } else {
      // Provider가 이미 dispose된 경우 카메라도 해제
      await controller.dispose();
      return null;
    }

    // 명시적인 dispose 콜백 등록
    ref.onDispose(() {
      print('카메라 컨트롤러 해제 중...');
      controller
          .dispose()
          .then((_) {
            print('카메라 컨트롤러 해제 완료');
          })
          .catchError((e) {
            print('카메라 컨트롤러 해제 오류: $e');
          });
    });

    return controller;
  } catch (e) {
    print('카메라 초기화 오류: $e');
    return null;
  }
});

// 이미지 캡처
final captureImageProvider = Provider<Future<File?> Function()>((ref) {
  return () async {
    try {
      final controller = await ref.read(cameraControllerProvider.future);
      if (controller == null || !controller.value.isInitialized) {
        return null;
      }

      final xFile = await controller.takePicture();

      return File(xFile.path);
    } catch (e) {
      print('이미지 캡처 오류: $e');
      return null;
    }
  };
});

// 카운트다운 타이머 상태 관리
final countdownProvider = StateNotifierProvider<CountdownNotifier, int>((ref) {
  final sequence = ref.read(selectedSequenceProvider);
  final currentIndex = ref.read(currentYogaIndexProvider);

  int initialSeconds = 0;
  if (sequence != null && currentIndex < sequence.yogaSequence.length) {
    initialSeconds = sequence.yogaSequence[currentIndex].yogaTime;
  }

  return CountdownNotifier(ref, initialSeconds);
});

class CountdownNotifier extends StateNotifier<int> {
  final Ref _ref;
  Timer? _timer;

  CountdownNotifier(this._ref, int initialSeconds) : super(initialSeconds);

  void startCountdown(int seconds) {
    _timer?.cancel();

    // 초기 시간 설정
    state = seconds;

    // 타이머 시작
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 1) {
        state = state - 1;
      } else {
        // 다음 요가 동작으로 이동
        _moveToNextYoga();
      }
    });
  }

  void cancelSession() {
    _timer?.cancel();
    _ref.read(isCancelledProvider.notifier).state = true;

    // 초기 상태로 리셋
    _ref.read(currentYogaIndexProvider.notifier).state = 0;
    _ref.read(learningStateProvider.notifier).state = LearningState.initial;
    _ref.read(isSequenceCompletedProvider.notifier).state = false;
  }

  void _moveToNextYoga() {
    final sequenceProvider = _ref.read(selectedSequenceProvider);
    final currentIndex = _ref.read(currentYogaIndexProvider);

    print('요가 동작 $currentIndex 완료, 다음 동작으로 이동 시도');

    if (sequenceProvider == null) return;

    // 현재 요가 동작의 정확도 저장
    if (currentIndex >= 0) {
      try {
        _saveYogaAccuracy(sequenceProvider, currentIndex);
      } catch (e) {
        print('정확도 저장 오류: $e');
      }
    }

    // 다음 동작으로 이동하거나 시퀀스 완료 처리
    if (currentIndex < sequenceProvider.yogaSequence.length - 1) {
      // 현재 인덱스에서 정확히 1 증가
      final nextIndex = currentIndex + 1;
      print('다음 요가 동작 $nextIndex으로 이동');

      // 기존 타이머 취소 확인
      _timer?.cancel();

      // 인덱스 업데이트
      _ref.read(currentYogaIndexProvider.notifier).state = nextIndex;
      _ref.read(learningStateProvider.notifier).state = LearningState.tutorial;

      // 요가 포즈 정보를 서버에 저장
      final learningService = _ref.read(learningServiceProvider);
      final userSequenceId = _ref.read(userSequenceIdProvider);

      if (userSequenceId != null) {
        print("userSequenceId 전송: $userSequenceId");
        try {
          learningService.saveYogaPose(userSequenceId);
        } catch (e) {
          print('요가 포즈 저장 오류 (무시): $e');
        }
      }
    } else {
      print('모든 요가 동작 완료, 결과 화면으로 이동');
      _completeSequence();
    }
  }

  // 요가 동작의 정확도 저장
  void _saveYogaAccuracy(SequenceDetailModel sequence, int yogaIndex) {
    try {
      final learningService = _ref.read(learningServiceProvider);
      final userSequenceId = _ref.read(userSequenceIdProvider);

      print("userSequencId: $userSequenceId");
      if (userSequenceId != null) {
        print("요가 동작 정확도 저장");

        final yogaId = sequence.yogaSequence[yogaIndex].yogaId;
        learningService.saveAccuracyComplete(
          userSequenceId: userSequenceId,
          yogaId: yogaId,
          sequenceId: sequence.sequenceId,
        );
      }
    } catch (e) {
      print('자세 정확도 저장 에러!!: $e');
    }
  }

  // 시퀀스 완료
  void _completeSequence() {
    _timer?.cancel();
    _ref.read(isSequenceCompletedProvider.notifier).state = true;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// 시퀀스 완료 상태 관리
final isSequenceCompletedProvider = StateProvider<bool>((ref) => false);

// 요가 취소 상태 관리
final isCancelledProvider = StateProvider<bool>((ref) => false);
