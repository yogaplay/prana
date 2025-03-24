import 'package:flutter/material.dart';
import 'package:frontend/features/search/widgets/search_bar_with_filter.dart';

class SearchInputScreen extends StatelessWidget {
  const SearchInputScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FocusNode searchFocusNode = FocusNode();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: SearchBarWithFilter(focusNode: searchFocusNode),
        ),
      ),
    );
  }
}
