import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';
import 'package:frontend/features/learning/screens/learning/practice_view.dart';
import 'package:frontend/features/learning/screens/learning/skip_view.dart';
import 'package:frontend/features/learning/screens/learning/tutorial_view.dart';

class LearningScreen extends ConsumerStatefulWidget {
  final int sequenceId;

  const LearningScreen({super.key, required this.sequenceId});

  @override
  ConsumerState<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends ConsumerState<LearningScreen> {
  @override
  void initState() {
    super.initState();

    print('화면방향 가로로 설정');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 학습 상태 초기화
      ref.read(learningStateProvider.notifier).state = LearningState.initial;
      ref.read(currentYogaIndexProvider.notifier).state = 0;
      ref.read(skipAllTutorialsProvider.notifier).state = false;
    });
  }

  @override
  void dispose() {
    print('화면 방향 세로로 설정');
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void onNextYoga() {
    final currentIndex = ref.read(currentYogaIndexProvider);
    final sequenceDetail = ref.read(selectedSequenceProvider);

    if (sequenceDetail == null) return;

    if (currentIndex < sequenceDetail.yogaCnt - 1) {
      ref.read(currentYogaIndexProvider.notifier).state = currentIndex + 1;
      ref.read(learningStateProvider.notifier).state = LearningState.tutorial;
    } else {
      ref.read(learningStateProvider.notifier).state = LearningState.completed;
    }
  }

  @override
  Widget build(BuildContext context) {
    final learningState = ref.watch(learningStateProvider);

    if (learningState == LearningState.completed) {
      // 결과 리포트 화면 이동 추가해야됨
    }

    return Scaffold(
      body: Stack(
        children: [
          if (learningState == LearningState.initial) const SkipView(),
          if (learningState == LearningState.tutorial)
            TutorialView(sequenceId: widget.sequenceId),
          if (learningState == LearningState.practice)
            PracticeView(sequenceId: widget.sequenceId),
        ],
      ),
    );
  }
}
