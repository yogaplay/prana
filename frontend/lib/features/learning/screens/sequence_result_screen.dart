import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/learning/models/pose_result.dart';
import 'package:frontend/features/learning/models/sequence_result_response.dart';
import 'package:frontend/features/learning/providers/sequence_result_provider.dart';
import 'package:frontend/features/learning/widgets/result/completed_sequence_banner.dart';
import 'package:frontend/features/learning/widgets/result/congratulations_message.dart';
import 'package:frontend/features/learning/widgets/result/instability_summary_section.dart';
import 'package:frontend/features/learning/widgets/result/pose_result_summary_section.dart';
import 'package:frontend/features/learning/widgets/result/recommended_sequences_accordion.dart';
import 'package:frontend/features/learning/widgets/result/stat_card.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/widgets/button.dart';

class SequenceResultScreen extends ConsumerWidget {
  final int userSequenceId;
  final int sequenceId;

  SequenceResultScreen({
    super.key,
    required this.userSequenceId,
    required this.sequenceId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sequenceResultAsync = ref.watch(
      sequenceResultProvider((userSequenceId, sequenceId)),
    );

    return Scaffold(
      body: sequenceResultAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('에러 발생: $error')),
        data: (result) => _buildResultBody(context, result),
      ),
    );
  }

  Widget _buildResultBody(BuildContext context, SequenceResultResponse result) {
    return SafeArea(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 140),
            children: [
              CongratulationsMessage(),
              CompletedSequenceBanner(
                sequenceName: result.sequenceName,
                onSharePressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('공유 기능은 준비 중입니다!')));
                },
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: StatCard(
                      label: '운동 시간',
                      value: '${result.yogaTime}분',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      label: '완료 동작',
                      value: '${result.sequenceCnt}',
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: StatCard(
                      label: '정확도',
                      value: '${result.totalAccuracy}%',
                      showInfoIcon: true,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              InstabilitySummarySection(
                feedbackCounts: {
                  for (final item in result.totalFeedback)
                    item.position: item.feedbackCnt,
                },
              ),
              SizedBox(height: 16),
              RecommendedSequencesAccordion(
                recommendedSequences:
                    result.recommendSequence.map((r) {
                      return YogaItem(
                        id: r.sequenceId,
                        title: r.sequenceName,
                        duration: '${(r.sequenceTime / 60).round()}분',
                        imageUrl: r.sequenceImage,
                      );
                    }).toList(),
              ),
              SizedBox(height: 16),
              PoseResultSummarySection(
                results:
                    result.positionAccuracy.map((p) {
                      return PoseResult(
                        imageUrl: p.image,
                        poseName: p.yogaName,
                        accuracy: p.accuracy,
                        feedbacks:
                            p.feedback
                                .map(
                                  (f) => PoseFeedbackItem(
                                    feedback: f.feedback,
                                    feedbackCnt: f.feedbackCnt,
                                  ),
                                )
                                .toList(),
                      );
                    }).toList(),
              ),
            ],
          ),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(0, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 255, 255, 255),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(children: [Button(text: '종료', onPressed: () {})]),
          ),
        ],
      ),
    );
  }
}
