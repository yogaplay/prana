import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/profile_providers.dart';
import 'package:frontend/core/providers/providers.dart';
class EditNicknameScreen extends ConsumerStatefulWidget {
  final String initialNickname;

  const EditNicknameScreen({super.key, required this.initialNickname});

  @override
  ConsumerState<EditNicknameScreen> createState() => _EditNicknameScreenState();
}

class _EditNicknameScreenState extends ConsumerState<EditNicknameScreen> {
  late TextEditingController _controller;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialNickname);
    _validateInput(_controller.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _validateInput(String value) {
    setState(() {
      _isValid = value.length >= 2 && value.length <= 20;
    });
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '닉네임 변경',
              style: TextStyle(
                color: AppColors.blackText,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '앞으로 어떻게 불리고싶나요?',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.blackText,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.boxWhite,
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: InputBorder.none,
                  hintText: '닉네임을 입력하세요',
                  suffixIcon:
                      _controller.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              color: AppColors.lightGray,
                              size: 18,
                            ),
                            onPressed: () {
                              _controller.clear();
                              _validateInput('');
                            },
                          )
                          : null,
                ),
                onChanged: _validateInput,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '2~20자로 입력해주세요.',
              style: TextStyle(
                fontSize: 14,
                color: _isValid ? AppColors.graytext : Colors.red,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _isValid && _controller.text.isNotEmpty
                        ? () async {
                          final newNickname = _controller.text;
                          final success = await ref
                              .read(profileNotifierProvider.notifier)
                              .updateNickname(newNickname);

                          if (success) {
                            ref.invalidate(homeDataProvider); // 홈 데이터 최신화

                            if (context.mounted) {
                              Navigator.pop(context, newNickname); // 수정 후 닫기
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('닉네임 변경 실패')),
                              );
                            }
                          }
                        }
                      : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  disabledBackgroundColor: AppColors.lightGray,
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
