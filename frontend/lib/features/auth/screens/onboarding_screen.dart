import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png'),
            SizedBox(height: 20),
            Text(
              '요가로 깨우는 생명의 에너지',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 200),
            Text(
              '아직 계정이 없으세요?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            GestureDetector(
              onTap: () => _handleKakaoLogin(context, ref),
              child: Image.asset(
                'assets/images/kakao_login_medium_narrow.png',
                height: 45,
                fit: BoxFit.fitHeight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleKakaoLogin(BuildContext context, WidgetRef ref) async {
    final authService = ref.read(authServiceProvider);

    try {
      final kakaoToken = await authService.startWithKakao();
      final authResponse = await authService.getAuthTokens(
        kakaoToken.accessToken,
      );

      // AuthStateNotifier 업데이트
      final authNotifier = ref.read(authStateNotifierProvider.notifier);
      await authNotifier.login(
        accessToken: authResponse.pranaAccessToken,
        refreshToken: authResponse.pranaRefreshToken,
        isFirstLogin: authResponse.isFirst,
      );

      // 기존 Provider도 무효화
      ref.invalidate(authStateProvider);
      ref.invalidate(isFirstLoginProvider);

      // 로깅 추가
      print('로그인 성공, 인증 상태: ${ref.read(authStateNotifierProvider)}');

      // 직접 라우팅
      if (authResponse.isFirst) {
        if (context.mounted) context.goNamed("signup");
      } else {
        if (context.mounted) context.goNamed("home");
      }
    } catch (error) {
      print('로그인 실패 $error');
    }
  }
}
