import 'package:flutter/material.dart';
import 'package:frontend/widgets/tag.dart';
import 'package:go_router/go_router.dart';

class YogaTile extends StatelessWidget {
  final int sequenceId;
  final String imageUrl, title;
  final List<String> tags;

  const YogaTile({
    super.key,
    required this.sequenceId,
    required this.imageUrl,
    required this.title,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'sequenceDetail',
          pathParameters: {'id': sequenceId.toString()},
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children:
                              tags
                                  .map(
                                    (tag) => Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Tag(label: tag),
                                    ),
                                  )
                                  .toList(),
                        ),
                      ],
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
