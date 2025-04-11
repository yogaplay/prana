import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/models/yoga_category.dart';
import 'package:frontend/features/search/models/yoga_sequence.dart';
import 'package:frontend/features/search/screens/skeleton_search_main_screen.dart';
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
    return FutureBuilder<List<YogaCategory>>(
      future: _futureCategories,
      builder: (context, snapshot) {
        // 로딩 중일 때는 스켈레톤 UI 전체 화면 반환
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SkeletonSearchMainScreen(
            selectedFilters: selectedFilters,
            onSearchTap: _goToSearchInput,
            onFilterApply: _onFilterApply,
          );
        }

        // 에러 또는 데이터가 없는 경우
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Scaffold(
            body: SafeArea(
              child: ListView(
                children: [
                  // 상단 타이틀
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 25,
                      right: 25,
                      left: 25,
                      bottom: 0,
                    ),
                    child: Text(
                      '둘러보기',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.blackText,
                      ),
                    ),
                  ),
                  // 검색 바
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 25,
                    ),
                    child: SearchBarWithFilter(
                      readOnly: true,
                      onTap: _goToSearchInput,
                      selectedFilters: selectedFilters,
                      onFilterApply: _onFilterApply,
                    ),
                  ),
                  // 에러 또는 빈 데이터 메시지
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Text(
                        snapshot.hasError
                            ? '데이터를 불러올 수 없습니다. ${snapshot.error}'
                            : '요가 콘텐츠가 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.graytext,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // 데이터가 있는 경우의 실제 화면
        final categories = snapshot.data!;

        return Scaffold(
          body: SafeArea(
            child: ListView(
              children: [
                // 상단 타이틀
                Padding(
                  padding: const EdgeInsets.only(
                    top: 25,
                    right: 25,
                    left: 25,
                    bottom: 0,
                  ),
                  child: Text(
                    '둘러보기',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blackText,
                    ),
                  ),
                ),
                // 검색 바
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 25,
                  ),
                  child: SearchBarWithFilter(
                    readOnly: true,
                    onTap: _goToSearchInput,
                    selectedFilters: selectedFilters,
                    onFilterApply: _onFilterApply,
                  ),
                ),
                // 요가 카테고리 목록
                ...categories.map((category) {
                  return YogaCarousel(
                    title: category.tagName,
                    tagType: category.tagType,
                    items:
                        category.items
                            .map((item) => item.toYogaItem())
                            .toList(),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}
