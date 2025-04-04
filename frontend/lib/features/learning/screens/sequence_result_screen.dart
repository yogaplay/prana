import 'package:flutter/material.dart';
import 'package:frontend/features/learning/models/pose_result.dart';
import 'package:frontend/features/learning/widgets/result/completed_sequence_banner.dart';
import 'package:frontend/features/learning/widgets/result/congratulations_message.dart';
import 'package:frontend/features/learning/widgets/result/instability_summary_section.dart';
import 'package:frontend/features/learning/widgets/result/pose_result_summary_section.dart';
import 'package:frontend/features/learning/widgets/result/recommended_sequences_accordion.dart';
import 'package:frontend/features/learning/widgets/result/stat_card.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/widgets/button.dart';

class SequenceResultScreen extends StatelessWidget {
  const SequenceResultScreen({super.key});

  List<YogaItem> get dummyRecommendedSequences => [
    YogaItem(
      id: 1,
      title: '허리를 위한 요가',
      duration: '15분',
      imageUrl: 'https://picsum.photos/150/100',
    ),
    YogaItem(
      id: 2,
      title: '하체 안정 루틴',
      duration: '12분',
      imageUrl: 'https://picsum.photos/150/100',
    ),
    YogaItem(
      id: 3,
      title: '전신 스트레칭',
      duration: '10분',
      imageUrl: 'https://picsum.photos/150/100',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final dummyPoseResults = [
      PoseResult(
        imageUrl: 'https://picsum.photos/100',
        poseName: '아도 무카 비라사나',
        accuracy: 87,
      ),
      PoseResult(
        imageUrl: 'https://picsum.photos/100',
        poseName: '차투랑가 단다사나',
        accuracy: 79,
      ),
      PoseResult(
        imageUrl: 'https://picsum.photos/100',
        poseName: '우타나아사나',
        accuracy: 92,
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 140),
              children: [
                CongratulationsMessage(),
                CompletedSequenceBanner(
                  sequenceName: '엉덩이를 위한 요가 시퀀스',
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
                    Expanded(child: StatCard(label: '운동 시간', value: '8분')),
                    SizedBox(width: 16),
                    Expanded(child: StatCard(label: '완료 동작', value: '5개')),
                    SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        label: '정확도',
                        value: '85%',
                        showInfoIcon: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                InstabilitySummarySection(
                  feedbackCounts: {'어깨': 3, '엉덩이': 5, '손목': 1},
                ),
                SizedBox(height: 16),
                RecommendedSequencesAccordion(
                  recommendedSequences: dummyRecommendedSequences,
                ),
                SizedBox(height: 16),
                PoseResultSummarySection(results: dummyPoseResults),
              ],
            ),
            _buildBottomButton(context),
          ],
        ),
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
