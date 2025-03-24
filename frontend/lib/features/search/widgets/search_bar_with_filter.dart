import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class SearchBarWithFilter extends StatelessWidget {
  const SearchBarWithFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
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
          IconButton(onPressed: () {}, icon: Icon(Icons.filter_alt_outlined)),
        ],
      ),
    );
  }
}
