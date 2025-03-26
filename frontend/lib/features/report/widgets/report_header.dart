import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class ReportHeader extends StatelessWidget {
  const ReportHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      '2025년 3월 4주차',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppColors.blackText,
      ),
    );
  }
}
