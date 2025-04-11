import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/widgets/search_bar_with_filter.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonSearchMainScreen extends StatelessWidget {
  final List<String> selectedFilters;
  final VoidCallback onSearchTap;
  final Function(List<String>) onFilterApply;

  const SkeletonSearchMainScreen({
    super.key,
    this.selectedFilters = const [],
    required this.onSearchTap,
    required this.onFilterApply,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 25,
                right: 25,
                left: 25,
                bottom: 0,
              ),
              child: Text(
                '둘러보기',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackText,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
              child: SearchBarWithFilter(
                readOnly: true,
                onTap: onSearchTap,
                selectedFilters: selectedFilters,
                onFilterApply: onFilterApply,
              ),
            ),
            // 스켈레톤 요가 캐러셀 (3개 표시)
            for (var i = 0; i < 3; i++) _buildSkeletonYogaCarousel(),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonYogaCarousel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 제목 스켈레톤
              Shimmer.fromColors(
                baseColor: Color(0x33D9D9D9), // AppColors.lightGray + 투명도 20%
                highlightColor: Color(0x99FFFFFF), // 흰색 + 투명도 60%
                period: Duration(milliseconds: 2000), // 더 느린 효과
                child: Container(
                  width: 180,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // 전체 보기 버튼 스켈레톤
              Shimmer.fromColors(
                baseColor: Color(0x33D9D9D9), // AppColors.lightGray + 투명도 20%
                highlightColor: Color(0x99FFFFFF), // 흰색 + 투명도 60%
                period: Duration(milliseconds: 2000), // 더 느린 효과
                child: Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 170,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _buildSkeletonYogaCard(),
            separatorBuilder: (context, index) => SizedBox(width: 12),
            itemCount: 4, // 캐러셀당 4개 아이템
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSkeletonYogaCard() {
    // 카드의 정확한 크기 설정
    return SizedBox(
      width: 150,
      child: Shimmer.fromColors(
        baseColor: Color(0x33D9D9D9), // AppColors.lightGray + 투명도 20%
        highlightColor: Color(0x99FFFFFF), // 흰색 + 투명도 60%
        period: Duration(milliseconds: 2000), // 더 느린 효과
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 스켈레톤
            Container(
              width: 150,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목 스켈레톤
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  SizedBox(height: 8),
                  // 태그 스켈레톤
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        width: 40,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
