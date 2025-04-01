import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';
import 'package:frontend/features/learning/screens/learning/practice_view.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // device 방향 가로방향으로
      ref.read(orientationProvider.notifier).state = [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];

      // 학습 상태 초기화
      ref.read(learningStateProvider.notifier).state = LearningState.tutorial;
      ref.read(currentYogaIndexProvider.notifier).state = 0;
    });
  }

  @override
  void dispose() {
    // device 방향 세로방향으로
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  void _onComplete() {
    ref.read(learningStateProvider.notifier).state = LearningState.completed;
    // 리포트 화면으로 라우팅하는 코드 추가하기 ...
  }

  void _onNextYoga() {
    final currentIndex = ref.read(currentYogaIndexProvider);
    final sequenceDetail = ref.read(selectedSequenceProvider);

    if (sequenceDetail == null) return;

    if (currentIndex < sequenceDetail.yogaCnt - 1) {
      ref.read(currentYogaIndexProvider.notifier).state = currentIndex + 1;
      ref.read(learningStateProvider.notifier).state = LearningState.tutorial;
    } else {
      _onComplete();
    }
  }

  Widget build(BuildContext context) {
    final learningState = ref.watch(learningStateProvider);
    final currentYoga = ref.watch(currentYogaProvider);

    if (currentYoga == null) {
      // 뭔갈 반환하자 ..
    }
    return Scaffold(
      body: Stack(
        children: [
          if (learningState == LearningState.tutorial)
            TutorialView()
          else if (learningState == LearningState.practice)
            PracticeView(),
        ],
      ),
    );
  }
}
