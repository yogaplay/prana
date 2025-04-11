import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class GenderSelectionWidget extends StatelessWidget {
  final String selectedGender;
  final Function(String) onGenderSelected;

  const GenderSelectionWidget({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildGenderOption('여자', 'F'),
            SizedBox(width: 60),
            _buildGenderOption('남자', 'M'),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderOption(String label, String genderValue) {
    final bool isSelected = selectedGender == genderValue;
    final double iconSize = isSelected ? 120 : 100;

    return Column(
      children: [
        GestureDetector(
          onTap: () => onGenderSelected(genderValue),
          child: SizedBox(
            width: 120,
            height: 120,
            child: Center(
              child:
                  genderValue == 'F'
                      ? Icon(
                        Icons.female,
                        size: iconSize,
                        color:
                            isSelected
                                ? AppColors.primary
                                : AppColors.blackText,
                      )
                      : Icon(
                        Icons.male,
                        size: iconSize,
                        color:
                            isSelected
                                ? AppColors.primary
                                : AppColors.blackText,
                      ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.primary : AppColors.graytext,
          ),
        ),
      ],
    );
  }
}
