import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class InstabilitySummarySection extends StatelessWidget {
  final Map<String, int> feedbackCounts;

  const InstabilitySummarySection({super.key, required this.feedbackCounts});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '분석 결과',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 4),
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
                          title: Text('분석 기준'),
                          content: Text(
                            '총 11개 부위의 불안정한 자세 횟수를 다음과 같이 그룹별로 분류하여 합산합니다:\n\n'
                            '등 = 어깨\n'
                            '팔 = 왼팔 + 오른팔 + 왼팔꿈치 + 오른팔꿈치\n'
                            '코어 = 왼엉덩이 + 오른엉덩이\n'
                            '다리 = 왼무릎 + 오른무릎 + 왼다리 + 오른다리',
                            style: TextStyle(fontSize: 15),
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
                child: Icon(
                  Icons.info_outline_rounded,
                  size: 16,
                  color: AppColors.graytext,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ...feedbackCounts.entries.map(
            (entry) => RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: AppColors.blackText),
                children: [
                  TextSpan(
                    text: entry.key,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: '에서 '),
                  TextSpan(
                    text: '${entry.value}회',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 16, color: AppColors.blackText),
              children: [
                TextSpan(
                  text: '불안정한 자세',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' 가 발견되었습니다!'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
