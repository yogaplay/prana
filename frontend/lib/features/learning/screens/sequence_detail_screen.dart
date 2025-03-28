import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/learning/models/sequence_detail_model.dart';
import 'package:frontend/features/learning/widgets/pose_item.dart';
import 'package:frontend/features/learning/widgets/sequence_header.dart';
import 'package:frontend/features/learning/widgets/sequence_info.dart';
import 'package:frontend/widgets/button.dart';

class SequenceDetailScreen extends ConsumerWidget {
  final int sequenceId;

  const SequenceDetailScreen({super.key, required this.sequenceId});
  
  String _formatDuration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainingSeconds = seconds % 60;

    if (minutes > 0) {
      return '$minutes분 ${remainingSeconds > 0 ? "$remainingSeconds초" : ""}';
    } else {
      return '$seconds초';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod을 사용하여 시퀀스 상세 데이터 가져오기
    final sequenceDetailAsync = ref.watch(sequenceDetailProvider(sequenceId));

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: sequenceDetailAsync.when(
          // 로딩 상태
          loading:
              () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),

          // 에러 상태
          error:
              (error, stackTrace) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '데이터를 불러오는 중 오류가 발생했습니다',
                      style: TextStyle(fontSize: 16, color: AppColors.graytext),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref.invalidate(sequenceDetailProvider(sequenceId));
                      },
                      child: const Text('다시 시도'),
                    ),
                  ],
                ),
              ),

          // 데이터 로드 성공
          data: (sequence) => _buildContent(context, sequence, ref),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    SequenceDetailModel sequence,
    WidgetRef ref,
  ) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              // 상단 이미지랑 뒤로가기 버튼
              SequenceHeader(imageUrl: sequence.sequenceImage),

              // 요가 시퀀스 정보
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // 시퀀스 제목 및 즐겨찾기 버튼
                    SequenceInfo(
                      title: sequence.sequenceName,
                      duration: _formatDuration(sequence.time),
                      poseCount: '${sequence.yogaCnt}개의 동작',
                      description: sequence.description,
                    ),

                    const SizedBox(height: 32),
                    const Text(
                      '운동',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackText,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 포즈 리스트
                    _buildPoseList(sequence),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ],
          ),
        ),

        // 하단 고정된 시작하기 버튼
        _buildBottomButton(context, sequence, ref),
      ],
    );
  }

  Widget _buildPoseList(SequenceDetailModel sequence) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sequence.yogaSequence.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final yoga = sequence.yogaSequence[index];
        return PoseItem(
          imageUrl: yoga.image,
          title: yoga.yogaName,
          duration: '${yoga.yogaTime}초',
        );
      },
    );
  }

  Widget _buildBottomButton(
    BuildContext context,
    SequenceDetailModel sequence,
    WidgetRef ref,
  ) {
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
            child: Column(children: [Button(text: '시작하기', onPressed: () {})]),
          ),
        ],
      ),
    );
  }
}
