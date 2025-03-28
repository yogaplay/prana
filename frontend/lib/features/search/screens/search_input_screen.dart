import 'package:flutter/material.dart';
import 'package:frontend/features/search/screens/search_result_screen.dart';
import 'package:frontend/features/search/widgets/search_bar_with_filter.dart';

class SearchInputScreen extends StatelessWidget {
  final Function(String keyword) onSubmitted;

  const SearchInputScreen({super.key, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    final FocusNode searchFocusNode = FocusNode();
    final controller = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SearchBarWithFilter(
            focusNode: searchFocusNode,
            readOnly: false,
            controller: controller,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (_) => SearchResultScreen(
                          keyword: value.trim(),
                          selectedFilters: [],
                        ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
