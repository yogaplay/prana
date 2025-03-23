import 'package:flutter/material.dart';
import 'package:frontend/features/search/models/yoga_item.dart';

class YogaCard extends StatelessWidget {
  final YogaItem item;

  const YogaCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
          Text(item.duration, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
