import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final bool showInfoIcon;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.showInfoIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 16, color: AppColors.blackText),
              ),
              if (showInfoIcon)
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: AppColors.background,
                            title: Text('정확도란?'),
                            content: Text(
                              '정확도는 모범 자세를 기준으로 핵심 신체 부위의 각도 차이를 분석하여 산출합니다.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                ),
                                child: Text('확인'),
                              ),
                            ],
                          ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 4),
                    child: Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: AppColors.graytext,
                    ),
                  ),
                ),
            ],
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
