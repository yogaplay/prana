import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';

class SkipView extends ConsumerWidget {
  const SkipView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sequenceDetail = ref.watch(selectedSequenceProvider);

    // sequenceDetail이 null인 경우 로딩 표시
    if (sequenceDetail == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Stack(
      children: [
        // 배경 이미지 (시퀀스 이미지)
        Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(sequenceDetail.sequenceImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.black.withOpacity(0.4),
              width: double.infinity,
              height: double.infinity,
            ),
          ],
        ),

        // 텍스트 및 버튼
        Positioned.fill(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end, // 오른쪽 정렬
              children: [
                const Spacer(flex: 2),
                Container(
                  alignment: Alignment.centerRight, // 오른쪽 정렬
                  child: const Text(
                    '모든 튜토리얼 영상을\n 스킵할까요?',
                    textAlign: TextAlign.right, // 오른쪽 정렬
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 18),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // 오른쪽 정렬
                  children: [
                    // 텍스트와 버튼들
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // 영상 시청하기 버튼
                        ElevatedButton(
                          onPressed: () {
                            // 튜토리얼 보기 선택
                            ref.read(skipAllTutorialsProvider.notifier).state =
                                false;
                            ref.read(learningStateProvider.notifier).state =
                                LearningState.tutorial;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '시청하기',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.play_arrow, size: 18),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // 스킵하기 버튼 (테두리만 하얀색인 버튼)
                        OutlinedButton(
                          onPressed: () {
                            // 모든 튜토리얼 스킵 선택
                            ref.read(skipAllTutorialsProvider.notifier).state =
                                true;
                            ref.read(learningStateProvider.notifier).state =
                                LearningState.practice;
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: const Text(
                            '스킵하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
