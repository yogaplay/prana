import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7ECECA),
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
              onTap: () => _handleKakaoLogin(context),
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

  Future<void> _handleKakaoLogin(BuildContext context) async {
    final authService = AuthService();
    
    try {
      final kakaoToken = await authService.startWithKakao();
      final AuthResponse = await authService.getAuthTokens(kakaoToken.accessToken);
      
    } catch (error) {
      print('로그인 실패 $error');
    }
  }
}
