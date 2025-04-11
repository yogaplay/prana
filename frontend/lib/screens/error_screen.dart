import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:go_router/go_router.dart';

class CommonErrorScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final String? retryButtonText;
  final String? homeButtonText;
  final String? backButtonText;
  final VoidCallback? onRetry;
  final VoidCallback? onHomePressed;
  final VoidCallback? onBackPressed;
  final IconData icon;
  final bool showHomeButton;
  final bool showBackButton;
  final String homePath;

  const CommonErrorScreen({
    super.key,
    this.title,
    this.message,
    this.retryButtonText,
    this.homeButtonText,
    this.backButtonText,
    this.onRetry,
    this.onHomePressed,
    this.onBackPressed,
    this.icon = Icons.sentiment_dissatisfied_rounded,
    this.showHomeButton = true,
    this.showBackButton = true,
    this.homePath = '/home',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 에러 아이콘
              Icon(icon, size: 80, color: AppColors.primary),

              const SizedBox(height: 24),

              // 에러 제목
              if (title != null)
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blackText,
                  ),
                ),

              const SizedBox(height: 12),

              // 에러 메시지
              Text(
                message ?? '데이터를 불러오는 중 오류가 발생했습니다',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: AppColors.graytext),
              ),

              const SizedBox(height: 40),

              // 다시 시도 버튼
              if (onRetry != null)
                _buildPrimaryButton(retryButtonText ?? '다시 시도', onRetry!),


              // 홈으로 돌아가기 버튼
              if (showHomeButton)
                _buildSecondaryButton(
                  homeButtonText ?? '홈으로 돌아가기',
                  onHomePressed ?? () => context.go(homePath),
                ),


              // 뒤로 가기 버튼
              if (showBackButton)
                _buildSecondaryButton(
                  backButtonText ?? '뒤로 가기',
                  onBackPressed ?? () => Navigator.of(context).pop(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
