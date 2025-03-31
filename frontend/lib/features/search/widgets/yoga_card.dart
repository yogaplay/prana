import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:go_router/go_router.dart';

class YogaCard extends StatelessWidget {
  final YogaItem item;

  const YogaCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('Tapped YogaCard with ID: ${item.id}');
        context.pushNamed(
          'sequenceDetail',
          pathParameters: {'id': item.id.toString()},
        );
      },
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.imageUrl,
                height: 100,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 4),
            Text(item.duration, style: TextStyle(color: AppColors.graytext)),
          ],
        ),
      ),
    );
  }
}
