import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/learning/models/sequence_detail_model.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';

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

// 사용 가능한 카메라 목록을 저장할 provider
final camerasProvider = FutureProvider<List<CameraDescription>>((ref) async {
  return await availableCameras();
});

// 카메라 컨트롤러 provider
final cameraControllerProvider = FutureProvider.autoDispose<CameraController?>((
  ref,
) async {
  final cameras = await ref.watch(camerasProvider.future);
  if (cameras.isEmpty) return null;

  final camera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.front,
    orElse: () => cameras.first,
  );

  final controller = CameraController(
    camera,
    ResolutionPreset.veryHigh, 
    enableAudio: false,
    imageFormatGroup: ImageFormatGroup.jpeg,
  );

  await controller.initialize();
  return controller;
});

// 카운트다운 타이머 상태를 관리하는 provider
final countdownProvider = StateNotifierProvider.autoDispose<CountdownNotifier, int>((ref) {
  return CountdownNotifier();
});

class CountdownNotifier extends StateNotifier<int> {
  CountdownNotifier() : super(0);
  Timer? _timer;

  void startCountdown(int seconds) {
    state = seconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state--;
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}