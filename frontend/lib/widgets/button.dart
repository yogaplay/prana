import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isDisabled;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        disabledBackgroundColor: AppColors.lightGray,
        disabledForegroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        fixedSize: Size(300, 56),
      ),
      child: Text(text),
    );
  }
}
