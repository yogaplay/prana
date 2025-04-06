import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';
import 'package:frontend/features/learning/screens/learning/practice_view.dart';
import 'package:frontend/features/learning/screens/learning/prepare_view.dart';
import 'package:frontend/features/learning/screens/learning/skip_view.dart';
import 'package:frontend/features/learning/screens/learning/tutorial_view.dart';
import 'package:go_router/go_router.dart';

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

    // 모든 시퀀스 완료 시
    if (learningState == LearningState.completed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 화면 방향을 세로로 변경
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

        // 결과 페이지로 이동
        if (mounted) {
          context.pushNamed('tempResult').then((_) {
            // 결과 페이지에서 돌아왔을 때 초기 상태로 리셋
            if (mounted) {
              ref.read(currentYogaIndexProvider.notifier).state = 0;
              ref.read(learningStateProvider.notifier).state =
                  LearningState.initial;
              ref.read(isSequenceCompletedProvider.notifier).state = false;
            }
          });
        }
        ref.read(learningStateProvider.notifier).state = LearningState.initial;
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        // 뒤로가기 버튼이 눌렸을 때 확인 다이얼로그 표시
        final shouldPop =
            await showDialog<bool>(
              context: context,
              builder:
                  (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: AppColors.boxWhite,
                    title: Text(
                      '확인',
                      style: TextStyle(
                        color: AppColors.blackText,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    content: Text(
                      '지금 종료하시겠습니까?',
                      style: TextStyle(color: AppColors.graytext, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          // 세션 상태 초기화
                          ref.read(currentYogaIndexProvider.notifier).state = 0;
                          ref.read(learningStateProvider.notifier).state =
                              LearningState.initial;
                          ref.read(isSequenceCompletedProvider.notifier).state =
                              false;

                          // 타이머 취소 - 메소드 호출
                          ref.read(countdownProvider.notifier).cancelSession();

                          Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          '예',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.lightGray,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          '아니오',
                          style: TextStyle(
                            color: AppColors.blackText,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
            ) ??
            false;

        if (shouldPop && mounted) {
          Navigator.of(context).pop(); // 현재 화면 닫기
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            if (learningState == LearningState.initial) const SkipView(),
            if (learningState == LearningState.tutorial)
              TutorialView(sequenceId: widget.sequenceId),
            if (learningState == LearningState.preparing)
              PrepareView(sequenceId: widget.sequenceId),
            if (learningState == LearningState.practice)
              PracticeView(sequenceId: widget.sequenceId),
          ],
        ),
      ),
    );
  }
}
