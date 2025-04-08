import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/widgets/search_bar_with_filter.dart';
import 'package:frontend/widgets/tag.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonSearchResultScreen extends StatelessWidget {
  final String keyword;
  final List<String> selectedFilters;
  final VoidCallback onRetry;

  const SkeletonSearchResultScreen({
    super.key,
    required this.keyword,
    required this.selectedFilters,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWithFilter(
                readOnly: false,
                onTap: () {},
                selectedFilters: selectedFilters,
                onSubmitted: (_) {},
                onFilterApply: (_) {},
              ),
              SizedBox(height: 16),
              if (keyword.isNotEmpty)
                Text("'$keyword' 에 대한 검색 결과", style: TextStyle(fontSize: 14)),
              if (keyword.isNotEmpty) SizedBox(height: 12),

              if (selectedFilters.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      selectedFilters.map((tag) => Tag(label: tag)).toList(),
                ),
              if (selectedFilters.isNotEmpty) SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  itemCount: 10, // 스켈레톤 아이템 개수
                  itemBuilder: (context, index) {
                    return _buildSkeletonYogaTile();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkeletonYogaTile() {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGray.withOpacity(0.4),
      highlightColor: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 이미지 스켈레톤
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목 스켈레톤
                  Container(
                    width: double.infinity,
                    height: 16,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8),
                  // 태그 스켈레톤
                  Row(
                    children: List.generate(
                      3,
                      (index) => Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Container(
                          width: 60,
                          height: 24,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
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
