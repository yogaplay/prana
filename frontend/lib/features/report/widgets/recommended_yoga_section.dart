import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/features/search/widgets/yoga_carousel.dart';

class RecommendedYogaSection extends StatefulWidget {
  final Map<String, List<YogaItem>> recommendedItems;

  const RecommendedYogaSection({super.key, required this.recommendedItems});

  @override
  State<RecommendedYogaSection> createState() => _RecommendedYogaSectionState();
}

class _RecommendedYogaSectionState extends State<RecommendedYogaSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '이런 요가는 어떠세요?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.graytext,
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: AppColors.graytext,
                ),
              ],
            ),
          ),
        ),
        if (_expanded)
          ...widget.recommendedItems.entries.map((entry) {
            return YogaCarousel(
              title: entry.key,
              items: entry.value,
              tagType: '운동 부위',
              padding: EdgeInsets.zero,
            );
          }),
      ],
    );
  }
}
