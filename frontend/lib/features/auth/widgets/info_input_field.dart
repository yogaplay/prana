import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/widgets/input_container.dart';

class InfoInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? unit; 
  final Widget? suffix; 
  final TextInputType keyboardType;

  const InfoInputField({
    super.key,
    required this.label,
    required this.controller,
    this.unit, 
    this.suffix,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final unitWidget =
        unit != null
            ? Text(
              unit!,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.graytext,
              ),
            )
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: AppColors.blackText,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 8),
        InputContainer(
          controller: controller,
          suffix: suffix ?? unitWidget,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
