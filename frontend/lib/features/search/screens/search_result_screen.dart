import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/models/yoga_search_result.dart';
import 'package:frontend/features/search/services/search_service.dart';
import 'package:frontend/features/search/widgets/search_bar_with_filter.dart';
import 'package:frontend/widgets/tag.dart';
import 'package:frontend/widgets/yoga_tile.dart';
import 'package:go_router/go_router.dart';

class SearchResultScreen extends StatefulWidget {
  final String keyword;
  final List<String> selectedFilters;

  const SearchResultScreen({
    super.key,
    required this.keyword,
    required this.selectedFilters,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  List<YogaSearchResult> results = [];
  int currentPage = 0;
  int totalPages = 1;
  bool isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchResults();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !isLoading &&
          currentPage < totalPages - 1) {
        _fetchResults();
      }
    });
  }

  Future<void> _fetchResults() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      final response = await SearchService.fetchSearchResults(
        keyword: widget.keyword,
        tagNames: widget.selectedFilters,
        page: currentPage,
      );

      setState(() {
        results.addAll(response['results']);
        totalPages = response['totalPages'];
        currentPage++;
      });
    } catch (e) {
      print('검색 오류: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _refreshWithKeyword(String newKeyword) {
    context.pushReplacement(
      '/search/result',
      extra: {'keyword': newKeyword, 'selectedFilters': widget.selectedFilters},
    );
  }

  void _refreshWithFilters(List<String> newFilters) {
    context.pushReplacement(
      '/search/result',
      extra: {'keyword': widget.keyword, 'selectedFilters': newFilters},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 25, left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWithFilter(
                readOnly: false,
                onTap: () {},
                selectedFilters: widget.selectedFilters,
                onSubmitted: _refreshWithKeyword,
                onFilterApply: _refreshWithFilters,
              ),
              SizedBox(height: 16),
              if (widget.keyword.isNotEmpty)
                Text(
                  "'${widget.keyword}' 에 대한 검색 결과",
                  style: TextStyle(fontSize: 14),
                ),
              if (widget.keyword.isNotEmpty) SizedBox(height: 12),

              if (widget.selectedFilters.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      widget.selectedFilters
                          .map((tag) => Tag(label: tag))
                          .toList(),
                ),
              if (widget.selectedFilters.isNotEmpty) SizedBox(height: 16),

              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: results.length + 1,
                  itemBuilder: (context, index) {
                    if (index < results.length) {
                      final item = results[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: YogaTile(
                          sequenceId: item.sequenceId,
                          imageUrl: item.image,
                          title: item.sequenceName,
                          tags: item.tagList,
                        ),
                      );
                    } else {
                      return isLoading
                          ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                          : SizedBox.shrink();
                    }
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
