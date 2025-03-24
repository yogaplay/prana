import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/search/widgets/filter_bottom_sheet.dart';

class SearchBarWithFilter extends StatelessWidget {
  final bool readOnly;
  final VoidCallback? onTap;
  final FocusNode? focusNode;

  const SearchBarWithFilter({
    super.key,
    this.readOnly = false,
    this.onTap,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              readOnly: readOnly,
              onTap: onTap,
              focusNode: focusNode,
              autofocus: focusNode != null,
              decoration: InputDecoration(
                hintText: '검색어를 입력하세요',
                prefixIcon: Icon(Icons.search),
                contentPadding: EdgeInsets.symmetric(vertical: 0),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.graytext),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.graytext, width: 2),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (_) => FilterBottomSheet(),
              );
            },
            icon: Icon(Icons.filter_alt_outlined),
          ),
        ],
      ),
    );
  }
}
