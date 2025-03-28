import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/alarm/screens/alarm_setting_screen.dart';
import 'package:frontend/features/profile/screens/edit_profile_screen.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          '반가워요, 다이님 😊',
          style: TextStyle(
            color: AppColors.blackText,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 설정 섹션 제목
              Text(
                '설정',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blackText,
                ),
              ),
              const SizedBox(height: 16),

              // 설정 메뉴 아이템들
              _buildSettingItem(
                icon: Icons.person_outline,
                iconColor: AppColors.primary,
                title: '내 정보 수정',
                onTap: () {
                  // 내 정보 수정 페이지로 이동
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
              ),

              _buildSettingItem(
                icon: Icons.notifications_none_outlined,
                iconColor: AppColors.primary,
                title: '알림 설정',
                onTap: () {
                  // 알림 설정 페이지로 이동
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const NotificationSettingsScreen(),
                    ),
                  );
                },
              ),

              _buildSettingItem(
                icon: Icons.play_circle_outline,
                iconColor: AppColors.primary,
                title: '배경음악 선택',
                onTap: () {
                  // 배경음악 선택 페이지로 이동
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 설정 메뉴 아이템 위젯
  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.blackText,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.graytext, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
