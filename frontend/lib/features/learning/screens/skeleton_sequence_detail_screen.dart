import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class SequenceDetailSkeletonScreen extends StatefulWidget {
  const SequenceDetailSkeletonScreen({super.key});

  @override
  State<SequenceDetailSkeletonScreen> createState() =>
      _SequenceDetailSkeletonScreenState();
}

class _SequenceDetailSkeletonScreenState
    extends State<SequenceDetailSkeletonScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      // 헤더 이미지 스켈레톤
                      _buildHeaderSkeleton(),

                      // 요가 시퀀스 정보 스켈레톤
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),

                            // 시퀀스 정보 스켈레톤
                            _buildSequenceInfoSkeleton(),

                            const SizedBox(height: 32),

                            // '운동' 제목
                            _buildSkeletonBox(60, 24, radius: 4),

                            const SizedBox(height: 16),

                            // 포즈 리스트 스켈레톤
                            _buildPoseListSkeleton(),

                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 하단 고정된 버튼 스켈레톤
                _buildBottomButtonSkeleton(),
              ],
            );
          },
        ),
      ),
    );
  }

  // 스켈레톤 박스 위젯 (재사용 가능)
  Widget _buildSkeletonBox(
    double width,
    double height, {
    double radius = 8,
    Color? color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color:
            color ??
            Colors.grey.withAlpha((_animation.value * 0.2 * 255).toInt()),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  // 헤더 이미지 스켈레톤
  Widget _buildHeaderSkeleton() {
    return Stack(
      children: [
        // 이미지 영역
        Container(
          width: double.infinity,
          height: 200,
          color: Colors.grey.withAlpha((_animation.value * 0.15 * 255).toInt()),
        ),

        // 그라데이션 오버레이
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white.withAlpha(0), Colors.white],
              ),
            ),
          ),
        ),

        // 뒤로가기 버튼
        Positioned(
          top: 16,
          left: 16,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(179), // 0.7 * 255 = 178.5 ≈ 179
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  // 시퀀스 정보 스켈레톤
  Widget _buildSequenceInfoSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목 및 즐겨찾기 버튼
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _buildSkeletonBox(double.infinity, 28, radius: 4)),
            const SizedBox(width: 16),
            _buildSkeletonBox(32, 32, radius: 16),
          ],
        ),

        const SizedBox(height: 12),

        // 시간 및 포즈 수 정보
        Row(
          children: [
            _buildSkeletonBox(80, 16, radius: 4),
            const SizedBox(width: 8),
            Text(
              '|',
              style: TextStyle(
                color: Colors.grey.withAlpha(
                  (_animation.value * 0.3 * 255).toInt(),
                ),
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
            _buildSkeletonBox(100, 16, radius: 4),
          ],
        ),

        const SizedBox(height: 20),

        // 설명 텍스트
        _buildSkeletonBox(double.infinity, 16, radius: 4),
        const SizedBox(height: 8),
        _buildSkeletonBox(double.infinity, 16, radius: 4),
        const SizedBox(height: 8),
        _buildSkeletonBox(
          MediaQuery.of(context).size.width * 0.7,
          16,
          radius: 4,
        ),
      ],
    );
  }

  // 포즈 리스트 스켈레톤
  Widget _buildPoseListSkeleton() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4, // 포즈 아이템 개수
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildPoseItemSkeleton();
      },
    );
  }

  // 포즈 아이템 스켈레톤
  Widget _buildPoseItemSkeleton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 포즈 이미지
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.secondary.withAlpha(
              (_animation.value * 0.5 * 255).toInt(),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const SizedBox(width: 20),

        // 포즈 정보
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 포즈 제목
              _buildSkeletonBox(150, 18, radius: 4),
              const SizedBox(height: 8),
              // 포즈 시간
              _buildSkeletonBox(60, 14, radius: 4),
            ],
          ),
        ),
      ],
    );
  }

  // 하단 버튼 스켈레톤
  Widget _buildBottomButtonSkeleton() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 그라데이션 효과
          Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white.withAlpha(0), Colors.white],
              ),
            ),
          ),
          // 버튼 컨테이너
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
            child: Center(
              child: Container(
                width: 300,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withAlpha(
                    (_animation.value * 0.7 * 255).toInt(),
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Container(
                  width: 80,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(
                      (_animation.value * 0.7 * 255).toInt(),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
