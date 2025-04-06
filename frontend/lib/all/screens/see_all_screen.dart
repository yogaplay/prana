import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/all/providers/see_all_provider.dart';
import 'package:frontend/widgets/yoga_tile.dart';

class SeeAllScreen extends ConsumerWidget {
  final String tagName;
  final String tagType;

  const SeeAllScreen({super.key, required this.tagName, required this.tagType});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final title = _getTitleWithTagType(tagName, tagType);
    final asyncItem = ref.watch(seeAllItemsProvider(tagName));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: asyncItem.when(
                  data: (items) {
                    if (items.isEmpty) {
                      return Center(child: Text('콘텐츠가 없습니다.'));
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return YogaTile(
                          imageUrl: item.image,
                          title: item.sequenceName,
                          tags: item.tags,
                        );
                      },
                    );
                  },
                  error: (error, _) => Center(child: Text('오류 발생: $error')),
                  loading: () => Center(child: CircularProgressIndicator()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
