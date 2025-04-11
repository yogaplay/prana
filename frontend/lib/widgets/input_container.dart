import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class InputContainer extends StatelessWidget {
  final TextEditingController controller;
  final Widget? suffix;
  final TextInputType keyboardType;
  final double width;
  final double height;

  const InputContainer({
    super.key,
    required this.controller,
    this.suffix,
    this.keyboardType = TextInputType.text,
    this.width = 300,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Color(0xFFF4F4F4), width: 1.0),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          if (suffix != null) suffix!,
        ],
      ),
    );
  }
}
