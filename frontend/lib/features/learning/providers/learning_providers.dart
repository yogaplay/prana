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

// 카메라 컨트롤러
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

    await controller.initialize();
    if (!controller.value.isInitialized) {
      throw Exception('카메라 초기화 실패');
    }

    ref.onDispose(() {
      controller.dispose();
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

  void _moveToNextYoga() {
    final sequenceProvider = _ref.read(selectedSequenceProvider);
    final currentIndex = _ref.read(currentYogaIndexProvider);

    if (sequenceProvider == null) return;

    // 현재 요가 동작의 정확도 저장
    if (currentIndex > 0) {
      _saveYogaAccuracy(sequenceProvider, currentIndex);
    }

    // 다음 동작으로 이동하거나 시퀀스 완료 처리
    if (currentIndex < sequenceProvider.yogaSequence.length - 1) {
      _moveToNextPose(sequenceProvider);
    } else {
      _completeSequence();
    }
  }

  // 요가 동작의 정확도 저장
  void _saveYogaAccuracy(SequenceDetailModel sequence, int yogaIndex) {
    try {
      final learningService = _ref.read(learningServiceProvider);
      final userSequenceId = _ref.read(userSequenceIdProvider);

      if (userSequenceId != null) {
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

  // 다음 요가 동작으로 이동
  void _moveToNextPose(SequenceDetailModel sequence) {
    // 다음 인덱스로 이동
    _ref.read(currentYogaIndexProvider.notifier).update((state) => state + 1);

    // 상태를 튜토리얼로 변경
    _ref.read(learningStateProvider.notifier).state = LearningState.tutorial;

    // 요가 포즈 정보를 서버에 저장
    final learningService = _ref.read(learningServiceProvider);
    final userSequenceId = _ref.read(userSequenceIdProvider);

    if (userSequenceId != null) {
      learningService.saveYogaPose(userSequenceId);
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
