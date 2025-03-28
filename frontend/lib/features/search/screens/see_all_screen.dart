import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/features/search/models/yoga_search_result.dart';
import 'package:frontend/features/search/services/search_service.dart';
import 'package:frontend/widgets/yoga_tile.dart';

class SeeAllScreen extends StatefulWidget {
  final String tagName;
  final String tagType;

  const SeeAllScreen({super.key, required this.tagName, required this.tagType});

  @override
  State<SeeAllScreen> createState() => _SeeAllScreenState();
}

class _SeeAllScreenState extends State<SeeAllScreen> {
  late Future<List<YogaSearchResult>> _futureResults;

  @override
  void initState() {
    super.initState();
    _futureResults = _fetchData();
  }

  Future<List<YogaSearchResult>> _fetchData() async {
    final response = await SearchService.fetchSearchResults(
      tagNames: [widget.tagName],
      page: 0,
      size: 20,
    );
    return response['results'] as List<YogaSearchResult>;
  }

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
  Widget build(BuildContext context) {
    final title = _getTitleWithTagType(widget.tagName, widget.tagType);

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
                child: FutureBuilder<List<YogaSearchResult>>(
                  future: _futureResults,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('오류 발생: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('콘텐츠가 없습니다.'));
                    }

                    final items = snapshot.data!;
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return YogaTile(
                          imageUrl: item.image,
                          title: item.sequenceName,
                          tags: item.tagList,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
