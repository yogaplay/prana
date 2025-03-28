import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/widgets/pose_item.dart';
import 'package:frontend/features/learning/widgets/sequence_header.dart';
import 'package:frontend/features/learning/widgets/sequence_info.dart';
import 'package:frontend/widgets/button.dart';

class SequenceDetail extends StatelessWidget {
  const SequenceDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // 상단 이미지랑 뒤로가기 버튼
                  const SequenceHeader(
                    imageUrl: 'assets/images/Baddhakonasana.png',
                  ),

                  // 요가 시퀀스 정보
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),

                        // 시퀀스 제목 및 즐겨찾기 버튼
                        const SequenceInfo(
                          title: '엉덩이를 위한 요가 시퀀스',
                          duration: '8분',
                          poseCount: '4개의 동작',
                          description:
                              '이 운동은 엉덩이를 쭉쭉빵빵 하게 해주는 운동입니다. 초심자에게 적합해요.',
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
                        _buildPoseList(),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 하단 고정된 시작하기 버튼
            _buildBottomButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildPoseList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return const PoseItem(
          imageUrl: 'assets/images/Baddhakonasana.png',
          title: '고양이 자세',
          duration: '1분 30초',
        );
      },
    );
  }

  Widget _buildBottomButton() {
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
            child: Column(
              children: [Button(text: '시작하기', onPressed: () => {})],
            ),
          ),
        ],
      ),
    );
  }
}
