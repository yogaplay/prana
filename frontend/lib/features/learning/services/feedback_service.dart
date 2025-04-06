import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';

/// 피드백 데이터를 담는 클래스
class FeedbackData {
  final dynamic learningService;
  final int userSequenceId;
  final int yogaId;

  FeedbackData({
    required this.learningService,
    required this.userSequenceId,
    required this.yogaId,
  });
}

/// 피드백 관련 기능을 관리하는 클래스
class FeedbackManager {
  final WidgetRef _ref;
  Timer? _shortFeedbackTimer;
  Timer? _longFeedbackTimer;

  final Function(bool?)? onFeedbackStatusChanged;

  FeedbackManager(this._ref, this.onFeedbackStatusChanged);

  /// 피드백 타이머 시작
  void startFeedback() {
    _shortFeedbackTimer = Timer.periodic(
      const Duration(milliseconds: 500),
      (_) => _getShortFeedback(),
    );

    _longFeedbackTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => _getLongFeedback(),
    );

    print('피드백 타이머 시작 완료');
  }

  /// 피드백 일시 중지
  void pauseFeedback() {
    _shortFeedbackTimer?.cancel();
    _longFeedbackTimer?.cancel();
  }

  /// 피드백 재개
  void resumeFeedback() {
    startFeedback();
  }

  /// 리소스 해제
  void dispose() {
    _shortFeedbackTimer?.cancel();
    _longFeedbackTimer?.cancel();
  }

  /// 짧은 피드백 가져오기
  Future<void> _getShortFeedback() async {
    try {
      final feedbackData = _getFeedbackData();
      if (feedbackData == null) return;

      final imageFile = await _captureImage();
      if (imageFile == null) return;

      final response = await feedbackData.learningService.sendShortFeedback(
        yogaId: feedbackData.yogaId,
        userSequenceId: feedbackData.userSequenceId,
        imageFile: imageFile,
      );

      final isSuccess = response == 'success';
      onFeedbackStatusChanged?.call(isSuccess);
    } catch (e) {
      print('에러 발생!! Short Feedback ERROR: $e');
    }
  }

  /// 긴 피드백 가져오기
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

  /// 피드백 데이터 가져오기
  FeedbackData? _getFeedbackData() {
    final learningService = _ref.read(learningServiceProvider);
    final userSequenceId = _ref.read(userSequenceIdProvider);
    final sequence = _ref.read(selectedSequenceProvider);
    final currentIndex = _ref.read(currentYogaIndexProvider);

    if (userSequenceId == null || sequence == null) return null;
    if (currentIndex >= sequence.yogaSequence.length) return null;

    final yogaId = sequence.yogaSequence[currentIndex].yogaId;

    return FeedbackData(
      learningService: learningService,
      userSequenceId: userSequenceId,
      yogaId: yogaId,
    );
  }

  /// 이미지 캡처
  Future<File?> _captureImage() async {
    try {
      final captureFunction = _ref.read(captureImageProvider);
      return await captureFunction();
    } catch (e) {
      print('카메라 캡처 오류: $e');
      return null;
    }
  }
}
