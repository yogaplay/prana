import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/widgets/filter_bottom_sheet.dart';

class SearchBarWithFilter extends StatelessWidget {
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final List<String> selectedFilters;
  final ValueChanged<List<String>>? onFilterApply;

  const SearchBarWithFilter({
    super.key,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
    this.controller,
    this.onSubmitted,
    this.selectedFilters = const [],
    this.onFilterApply,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            readOnly: readOnly,
            onTap: onTap,
            focusNode: focusNode,
            autofocus: focusNode != null,
            controller: controller,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              hintText: '검색어를 입력하세요',
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.lightGray),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.graytext, width: 2),
              ),
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder:
                  (_) => FilterBottomSheet(
                    initialSelectedFilters: selectedFilters,
                    onApply: (filters) {
                      Navigator.pop(context);
                      Future.delayed(Duration(milliseconds: 50), () {
                        if (onFilterApply != null) {
                          onFilterApply!(filters);
                        }
                      });
                    },
                  ),
            );
          },
          icon: Stack(
            children: [
              Icon(Icons.filter_alt_outlined, color: AppColors.graytext),
              if (selectedFilters.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
