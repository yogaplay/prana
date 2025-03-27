import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

import 'edit_age_screen.dart';
import 'edit_height_screen.dart';
import 'edit_nickname_screen.dart';
import 'edit_weight_screen.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // 사용자 정보 상태 관리
  String nickname = '다이';
  int age = 27;
  int height = 157;
  int weight = 44;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.blackText),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '내 정보 수정',
          style: TextStyle(
            color: AppColors.blackText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 닉네임 변경 섹션
              const Text(
                '닉네임 변경',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackText,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoField(
                title: nickname,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder:
                          (context) =>
                              EditNicknameScreen(initialNickname: nickname),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      nickname = result;
                    });
                  }
                },
              ),

              const SizedBox(height: 32),

              // 정보 변경 섹션
              const Text(
                '정보 변경',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackText,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoField(
                title: '나이',
                value: age,
                suffix: '세',
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EditAgeScreen(initialAge: age),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      age = result;
                    });
                  }
                },
              ),
              _buildInfoField(
                title: '신장',
                value: height,
                suffix: 'cm',
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder:
                          (context) => EditHeightScreen(initialHeight: height),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      height = result;
                    });
                  }
                },
              ),
              _buildInfoField(
                title: '체중',
                value: weight,
                suffix: 'kg',
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder:
                          (context) => EditWeightScreen(initialWeight: weight),
                    ),
                  );
                  if (result != null) {
                    setState(() {
                      weight = result;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 정보 필드 위젯 (나이, 신장, 체중)
  Widget _buildInfoField({
    String? title,
    int? value,
    String? suffix,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                if (value == null) ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.blackText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 8),
                  const Icon(Icons.edit, color: AppColors.graytext, size: 20),
                ] else ...[
                  Text(
                    title!,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.blackText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$value$suffix',
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.blackText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.graytext,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
