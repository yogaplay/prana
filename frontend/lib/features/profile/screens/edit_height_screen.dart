import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/widgets/number_input_field.dart';

class EditHeightScreen extends StatefulWidget {
  final int initialHeight;

  const EditHeightScreen({super.key, required this.initialHeight});

  @override
  State<EditHeightScreen> createState() => _EditHeightScreenState();
}

class _EditHeightScreenState extends State<EditHeightScreen> {
  late int _selectedHeight;

  @override
  void initState() {
    super.initState();
    _selectedHeight = widget.initialHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.blackText,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(21.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '신장',
              style: TextStyle(
                color: AppColors.blackText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // 제목
            Text(
              '키를 입력해주세요.',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.graytext,
              ),
            ),
            const SizedBox(height: 24),
            NumberInputField(
              initialValue: _selectedHeight,
              label: '키를 입력해주세요.',
              suffix: 'cm',
              minValue: 1,
              maxValue: 300,
              onValueChanged: (value) {
                setState(() {
                  _selectedHeight = value;
                });
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, _selectedHeight);
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
    );
  }
}
