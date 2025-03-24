import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/features/search/widgets/search_bar_with_filter.dart';
import 'package:frontend/features/search/widgets/yoga_carousel.dart';

class SearchMainScreen extends StatelessWidget {
  SearchMainScreen({super.key});

  final List<YogaItem> sampleItems = List.generate(
    5,
    (index) => YogaItem(
      title: '엉덩이를 위한 요가 시퀀스',
      duration: '30분',
      imageUrl: 'https://picsum.photos/100/150?random=1',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '둘러보기',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.blackText,
              ),
            ),
          ),
          SearchBarWithFilter(),
          YogaCarousel(
            title: '엉덩이를 위한 요가',
            items: sampleItems,
            onSeeAll: () {},
          ),
          YogaCarousel(title: '빈야사 요가', items: sampleItems, onSeeAll: () {}),
          YogaCarousel(
            title: '30분 이내의 요가',
            items: sampleItems,
            onSeeAll: () {},
          ),
          YogaCarousel(
            title: '초급자를 위한 요가',
            items: sampleItems,
            onSeeAll: () {},
          ),
        ],
      ),
    );
  }
}
