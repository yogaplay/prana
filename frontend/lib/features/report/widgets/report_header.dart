import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class ReportHeader extends StatelessWidget {
  final int year;
  final int month;
  final int week;

  const ReportHeader({
    super.key,
    required this.year,
    required this.month,
    required this.week,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$year년 $month월 $week주차',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.blackText,
      ),
    );
  }
}
