import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class CompletedSequenceBanner extends StatelessWidget {
  final String sequenceName;
  final VoidCallback onSharePressed;

  const CompletedSequenceBanner({
    super.key,
    required this.sequenceName,
    required this.onSharePressed,
  });

  String _getParticle(String text) {
    final lastChar = text.characters.last;
    final codeUnit = lastChar.codeUnitAt(0);

    if (codeUnit >= 0xAC00 && codeUnit <= 0xD7A3) {
      final localCode = codeUnit - 0xAC00;
      final jong = localCode % 28;
      return jong == 0 ? '를' : '을';
    }

    return '를';
  }

  @override
  Widget build(BuildContext context) {
    final particle = _getParticle(sequenceName);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.boxWhite,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: sequenceName,
                    style: TextStyle(
                      color: AppColors.blackText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '$particle\n',
                    style: TextStyle(color: AppColors.graytext, fontSize: 16),
                  ),
                  TextSpan(
                    text: '완료하였습니다!',
                    style: TextStyle(color: AppColors.graytext, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print('공유 버튼 누름');
                onSharePressed();
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.boxWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.lightGray),
                ),
                child: Icon(Icons.share, size: 20, color: AppColors.graytext),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
