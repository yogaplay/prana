import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/learning/models/sequence_detail_model.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';

enum LearningState { initial, tutorial, practice, completed }

// 현재 학습 상태 관리
final learningStateProvider = StateProvider<LearningState>((ref) {
    return LearningState.initial;
});

// 화면 방향 제어
final orientationProvider = StateProvider<List<DeviceOrientation>>((ref) {
  return [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ];
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