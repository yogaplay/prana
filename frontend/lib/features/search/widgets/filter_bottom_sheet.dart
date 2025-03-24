import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/widgets/button.dart';
import 'package:frontend/widgets/tag.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  final Set<String> selectedTags = {};

  Widget _buildChips(List<String> options) {
    return Wrap(
      spacing: 8,
      children:
          options.map((label) {
            final isSelected = selectedTags.contains(label);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedTags.remove(label);
                  } else {
                    selectedTags.add(label);
                  }
                });
              },
              child: Tag(
                label: label,
                isSelected: isSelected,
                hasBorder: !isSelected,
              ),
            );
          }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.65,
      minChildSize: 0.3,
      expand: false,
      builder: (_, controller) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FILTER',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 16),

              Expanded(
                child: ListView(
                  children: [
                    _buildSectionTitle('운동 부위'),
                    SizedBox(height: 12),
                    _buildChips(['엉덩이', '팔', '다리', '복부']),

                    SizedBox(height: 24),
                    _buildSectionTitle('난이도'),
                    SizedBox(height: 12),
                    _buildChips(['초급', '중급', '고급']),

                    SizedBox(height: 24),
                    _buildSectionTitle('시간'),
                    SizedBox(height: 12),
                    _buildChips(['10분 이내', '20분 이내', '30분 이상']),

                    SizedBox(height: 24),
                    _buildSectionTitle('유파'),
                    SizedBox(height: 12),
                    _buildChips(['아쉬탕가', '차크라', '하타', '아이옌가', '비나샤']),

                    SizedBox(height: 32),
                    Center(
                      child: Button(
                        text: '적용하기',
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildSectionTitle(String title) {
  return Text(
    title,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
  );
}
