import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';

/// 요가 세션 초기화 및 관리를 담당하는 클래스
class YogaSessionManager {
  final WidgetRef _ref;
  final int _sequenceId;

  YogaSessionManager(this._ref, this._sequenceId);

  /// 요가 세션 초기화
  Future<void> initialize() async {
    final currentIndex = _ref.read(currentYogaIndexProvider);

    // 여기에서 첫 번째 동작인 경우에만 요가 세션 시작 API 호출
    if (currentIndex == 0) {
      await _initializeFirstYoga();
    } else {
      await _initializeNextYoga(currentIndex);
    }
  }

  /// 첫 번째 요가 동작 초기화
  Future<void> _initializeFirstYoga() async {
    // 요가 시작
    final learningService = _ref.read(learningServiceProvider);
    final userSequenceId = await learningService.startYoga(_sequenceId);
    print('유저 시퀀스 ID: $userSequenceId');

    // 사용자 시퀀스 ID 저장
    _ref.read(userSequenceIdProvider.notifier).state = userSequenceId;

    // 시퀀스 정보 로드
    await _ref.read(sequenceDetailProvider(_sequenceId).future);
    print('시퀀스 정보 로드 완료');

    // 첫 번째 요가 동작의 타이머 시작
    await _startYogaTimer(0);

    // 첫 요가 포즈 저장
    await _saveYogaPose(userSequenceId);
  }

  /// 다음 요가 동작 초기화
  Future<void> _initializeNextYoga(int index) async {
    // 현재 요가 동작의 타이머 시작
    await _startYogaTimer(index);
  }

  /// 요가 타이머 시작
  Future<void> _startYogaTimer(int index) async {
    final sequence = _ref.read(selectedSequenceProvider);
    if (sequence == null || sequence.yogaSequence.isEmpty) {
      print('시퀀스 정보가 없거나 요가 시퀀스가 비어 있습니다.');
      return;
    }

    final yogaTime = sequence.yogaSequence[index].yogaTime;
    print('요가 동작 $index 시간: $yogaTime초');

    // 타이머 시작
    print('타이머 시작 시도');
    _ref.read(countdownProvider.notifier).startCountdown(yogaTime);
    print('타이머 시작 완료');
  }

  /// 요가 포즈 저장
  Future<void> _saveYogaPose(int userSequenceId) async {
    final learningService = _ref.read(learningServiceProvider);
    await learningService.saveYogaPose(userSequenceId);
  }
}
