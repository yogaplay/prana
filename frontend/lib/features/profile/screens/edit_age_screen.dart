import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/widgets/number_input_field.dart';

class EditAgeScreen extends StatefulWidget {
  final int initialAge;

  const EditAgeScreen({super.key, required this.initialAge});

  @override
  State<EditAgeScreen> createState() => _EditAgeScreenState();
}

class _EditAgeScreenState extends State<EditAgeScreen> {
  late int _selectedAge;

  @override
  void initState() {
    super.initState();
    _selectedAge = widget.initialAge;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          toolbarHeight: 80,
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 25),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.blackText,
                size: 24,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 21.0, left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '나이',
                style: TextStyle(
                  color: AppColors.blackText,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // 제목
              Text(
                '나이를 입력해주세요.',
                style: const TextStyle(fontSize: 16, color: AppColors.graytext),
              ),
              const SizedBox(height: 24),
              NumberInputField(
                initialValue: _selectedAge,
                label: '나이를 입력해주세요.',
                suffix: '세',
                minValue: 1,
                maxValue: 200,
                onValueChanged: (value) {
                  setState(() {
                    _selectedAge = value;
                  });
                },
              ),
              SizedBox(height: 12),
              // 제목
              Text(
                '한국 나이 기준',
                style: const TextStyle(fontSize: 16, color: AppColors.graytext),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, _selectedAge);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '저장하기',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
