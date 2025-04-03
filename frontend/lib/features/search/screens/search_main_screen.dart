import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/models/yoga_category.dart';
import 'package:frontend/features/search/models/yoga_sequence.dart';
import 'package:frontend/features/search/services/search_service.dart';
import 'package:frontend/features/search/widgets/search_bar_with_filter.dart';
import 'package:frontend/features/search/widgets/yoga_carousel.dart';
import 'package:go_router/go_router.dart';

class SearchMainScreen extends StatefulWidget {
  SearchMainScreen({super.key});

  @override
  State<SearchMainScreen> createState() => _SearchMainScreenState();
}

class _SearchMainScreenState extends State<SearchMainScreen> {
  List<String> selectedFilters = [];

  late Future<List<YogaCategory>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _futureCategories = SearchService.fetchMainYogaCategories();
  }

  void _goToSearchInput() {
    context.push(
      '/search/input',
      extra: (String keyword) {
        context.push(
          '/search/result',
          extra: {'keyword': keyword, 'selectedFilters': selectedFilters},
        );
      },
    );
  }

  void _onFilterApply(List<String> filters) {
    setState(() {
      selectedFilters = filters;
    });

    context.push(
      '/search/result',
      extra: {'keyword': '', 'selectedFilters': filters},
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final location = GoRouterState.of(context).uri.toString();
    print(location);
    if (location == '/search') {
      setState(() {
        selectedFilters = [];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchBarWithFilter(
                readOnly: true,
                onTap: _goToSearchInput,
                selectedFilters: selectedFilters,
                onFilterApply: _onFilterApply,
              ),
            ),
            FutureBuilder<List<YogaCategory>>(
              future: _futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('데이터를 불러올 수 없습니다. ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('요가 콘텐츠가 없습니다.'));
                }

                final categories = snapshot.data!;

                return Column(
                  children:
                      categories.map((category) {
                        return YogaCarousel(
                          title: category.tagName,
                          tagType: category.tagType,
                          items:
                              category.items
                                  .map((item) => item.toYogaItem())
                                  .toList(),
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
