import 'package:flutter/material.dart';
import 'package:frontend/app.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/features/search/screens/search_input_screen.dart';
import 'package:frontend/features/search/screens/search_result_screen.dart';
import 'package:frontend/features/search/widgets/search_bar_with_filter.dart';
import 'package:frontend/features/search/widgets/yoga_carousel.dart';

class SearchMainScreen extends StatefulWidget {
  SearchMainScreen({super.key});

  @override
  State<SearchMainScreen> createState() => _SearchMainScreenState();
}

class _SearchMainScreenState extends State<SearchMainScreen> with RouteAware {
  List<String> selectedFilters = [];

  final List<YogaItem> sampleItems = List.generate(
    5,
    (index) => YogaItem(
      title: '엉덩이를 위한 요가 시퀀스',
      duration: '30분',
      imageUrl: 'https://picsum.photos/100/150?random=1',
    ),
  );

  void _goToSearchInput() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SearchInputScreen(
              onSubmitted: (keyword) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => SearchResultScreen(
                          keyword: keyword,
                          selectedFilters: selectedFilters,
                        ),
                  ),
                );
              },
            ),
      ),
    );
  }

  void _onFilterApply(List<String> filters) {
    setState(() {
      selectedFilters = filters;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SearchResultScreen(keyword: '', selectedFilters: filters),
      ),
    );
  }

  @override
  void didPopNext() {
    setState(() {
      selectedFilters = [];
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
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
            YogaCarousel(
              title: '엉덩이를 위한 요가',
              items: sampleItems,
              onSeeAll: () {},
            ),
            YogaCarousel(title: '빈야사 요가', items: sampleItems, onSeeAll: () {}),
            YogaCarousel(
              title: '30분 이내의 요가',
              items: sampleItems,
              onSeeAll: () {},
            ),
            YogaCarousel(
              title: '초급자를 위한 요가',
              items: sampleItems,
              onSeeAll: () {},
            ),
          ],
        ),
      ),
    );
  }
}
