import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class Tag extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool hasBorder;
  final bool isUsedInFilter;

  const Tag({
    super.key,
    required this.label,
    this.isSelected = true,
    this.hasBorder = false,
    this.isUsedInFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isSelected ? AppColors.secondary : Colors.transparent;

    Color borderColor = Colors.transparent;

    if (isUsedInFilter) {
      borderColor =
          hasBorder
              ? AppColors.lightGray
              : AppColors.primary.withAlpha((0.3 * 255).toInt());
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.blackText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
