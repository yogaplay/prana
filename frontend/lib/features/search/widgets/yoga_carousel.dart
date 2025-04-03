import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/features/search/widgets/yoga_card.dart';
import 'package:go_router/go_router.dart';

class YogaCarousel extends StatelessWidget {
  final String title;
  final String tagType;
  final List<YogaItem> items;

  const YogaCarousel({
    super.key,
    required this.title,
    required this.items,
    required this.tagType,
  });

  String _getPostPosition(String word, String post1, String post2) {
    final lastChar = word.characters.last;
    final codeUnit = lastChar.codeUnitAt(0);

    if ((codeUnit - 0xAC00) % 28 != 0) {
      return post1;
    } else {
      return post2;
    }
  }

  String _getTitleWithTagType(String title, String tagType) {
    final practicle = _getPostPosition(title, '을', '를');

    switch (tagType) {
      case '운동 부위':
        return '$title$practicle 위한 요가';
      case '유파':
        return '$title 요가';
      case '난이도':
        return '$title자를 위한 요가';
      case '시간':
        return '$title 동안 하는 요가';
      default:
        return title;
    }
  }

  void _handleSeeAll(BuildContext context) {
    context.push('/see-all', extra: {'tagName': title, 'tagType': tagType});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getTitleWithTagType(title, tagType),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => _handleSeeAll(context),
                child: Row(
                  children: [
                    Text('전체 보기', style: TextStyle(color: AppColors.graytext)),
                    Icon(color: AppColors.graytext, Icons.chevron_right),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 170,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return YogaCard(item: items[index]);
            },
            separatorBuilder: (context, index) => SizedBox(width: 12),
            itemCount: items.length,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
