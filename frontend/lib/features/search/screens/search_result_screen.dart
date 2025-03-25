import 'package:flutter/material.dart';
import 'package:frontend/features/search/widgets/search_bar_with_filter.dart';
import 'package:frontend/widgets/tag.dart';
import 'package:frontend/widgets/yoga_tile.dart';

class SearchResultScreen extends StatelessWidget {
  final String keyword;
  final List<String> selectedFilters;

  const SearchResultScreen({
    super.key,
    required this.keyword,
    required this.selectedFilters,
  });

  List<Map<String, dynamic>> get dummyResults => [
    {
      'title': '엉덩이를 위한 요가 시퀀스',
      'tags': ['10분 이내', '엉덩이', '하타', '중급'],
      'imageUrl': 'https://picsum.photos/100/100?random=1',
    },
    {
      'title': '엉덩이를 위한 요가 시퀀스',
      'tags': ['하타', '중급'],
      'imageUrl': 'https://picsum.photos/100/100?random=2',
    },
    {
      'title': '엉덩이를 위한 요가 시퀀스',
      'tags': ['하타'],
      'imageUrl': 'https://picsum.photos/100/100?random=3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final results = dummyResults;

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
                onSubmitted: (value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => SearchResultScreen(
                            keyword: value.trim(),
                            selectedFilters: selectedFilters,
                          ),
                    ),
                  );
                },
                onFilterApply: (filters) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => SearchResultScreen(
                            keyword: keyword,
                            selectedFilters: filters,
                          ),
                    ),
                  );
                },
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
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return YogaTile(
                      imageUrl: item['imageUrl'],
                      title: item['title'],
                      tags: item['tags'],
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
