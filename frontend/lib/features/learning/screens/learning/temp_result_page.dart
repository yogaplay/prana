// lib/features/learning/screens/learning/temp_result_page.dart

import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class TempResultScreen extends StatelessWidget {
  const TempResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('요가 완료 결과 (테스트)'),
        backgroundColor: AppColors.primary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 20),
            const Text(
              '요가 시퀀스가 완료되었습니다!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            const Text(
              '축하합니다! 요가 세션을 성공적으로 완료했습니다.',
              style: TextStyle(fontSize: 16, color: AppColors.graytext),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              '이 페이지는 테스트용 결과 페이지입니다.',
              style: TextStyle(fontSize: 16, color: AppColors.graytext),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text('홈으로 돌아가기'),
            ),
          ],
        ),
      ),
    );
  }
}
