import 'package:flutter/material.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/features/search/widgets/yoga_card.dart';

class YogaCarousel extends StatelessWidget {
  final String title;
  final List<YogaItem> items;
  final VoidCallback onSeeAll;

  const YogaCarousel({
    super.key,
    required this.title,
    required this.items,
    required this.onSeeAll,
  });

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
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: onSeeAll,
                child: Row(
                  children: [
                    Text('전체 보기', style: TextStyle(color: Colors.grey)),
                    Icon(color: Colors.grey, Icons.chevron_right),
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
