import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/auth_providier.dart';
import 'package:frontend/core/providers/profile_providers.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/alarm/screens/alarm_setting_screen.dart';
import 'package:frontend/features/music/screens/music_selection_screen.dart';
import 'package:frontend/features/profile/screens/edit_profile_screen.dart';
import 'package:go_router/go_router.dart';

class InfoPage extends ConsumerWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: profileAsync.when(
          data:
              (profile) => Text(
                '반가워요, ${profile?.nickname}님 😊',
                style: TextStyle(
                  color: AppColors.blackText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
          loading:
              () => const Text(
                '반가워요 😊',
                style: TextStyle(
                  color: AppColors.blackText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
          error:
              (_, __) => const Text(
                '반가워요 😊',
                style: TextStyle(
                  color: AppColors.blackText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
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
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const MusicSelectionScreen(),
                    ),
                  );
                },
              ),

              // 로그아웃 아이템 추가
              _buildSettingItem(
                icon: Icons.exit_to_app,
                iconColor: AppColors.primary,
                title: '로그아웃',
                onTap: () {
                  // 로그아웃 확인 다이얼로그 표시
                  _showLogoutConfirmDialog(context, ref);
                },
              ),

              TextButton(
                onPressed: () {
                  context.push('/sequence-result');
                },
                child: Text('결과 페이지'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutConfirmDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('로그아웃'),
          content: Text('정말 로그아웃 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // 다이얼로그 닫기

                try {
                  // 로그아웃 처리
                  final authService = ref.read(authServiceProvider);
                  await authService.logout(); // 직접 AuthService의 로그아웃 메소드 호출

                  // 상태 변경을 시도하기 전에 context가 유효한지 확인
                  if (context.mounted) {
                    // 새로운 참조 얻기
                    final authNotifier = ref.read(
                      authStateNotifierProvider.notifier,
                    );
                    if (authNotifier is AuthStateNotifier) {
                      // 타입 확인
                      authNotifier.state = AuthState.unauthenticated();
                    }

                    // 직접 라우팅 처리
                    context.go('/onboarding');
                  }
                } catch (e) {
                  print('로그아웃 과정에서 오류 발생: $e');

                  // 오류가 발생해도 온보딩 페이지로 이동
                  if (context.mounted) {
                    context.go('/onboarding');
                  }
                }
              },
              child: Text('확인'),
            ),
          ],
        );
      },
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
