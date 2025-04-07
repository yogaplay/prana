import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

class CompletedSequenceBanner extends StatelessWidget {
  final String sequenceName;
  final String? imageUrlForKakao;
  final VoidCallback onSharePressed;

  const CompletedSequenceBanner({
    super.key,
    required this.sequenceName,
    this.imageUrlForKakao,
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

  FeedTemplate get defaultFeed {
    final fallbackUrl =
        'https://mud-kage.kakao.com/dn/Q2iNx/btqgeRgV54P/VLdBs9cvyn8BJXB3o7N8UK/kakaolink40_original.png';
    final img = imageUrlForKakao ?? fallbackUrl;
    return FeedTemplate(
      content: Content(
        title: '$sequenceName 완료!',
        description: '방금 $sequenceName을(를) 완료했어요. 함께 해보세요!',
        imageUrl: Uri.parse(img),
        link: Link(webUrl: Uri.parse(img), mobileWebUrl: Uri.parse(img)),
      ),
    );
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
          InkWell(
            onTap: _shareKakao,
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
        ],
      ),
    );
  }

  Future<void> _shareKakao() async {
    if (imageUrlForKakao == null) {
      onSharePressed();
      return;
    }
    try {
      bool isKakaoTalkSharingAvailable =
          await ShareClient.instance.isKakaoTalkSharingAvailable();

      if (isKakaoTalkSharingAvailable) {
        try {
          Uri uri = await ShareClient.instance.shareDefault(
            template: defaultFeed,
          );
          await ShareClient.instance.launchKakaoTalk(uri);
          print('카카오톡 공유 완료');
        } catch (error) {
          print('카카오톡 공유 실패 $error');
        }
      } else {
        try {
          Uri sharUrl = await WebSharerClient.instance.makeDefaultUrl(
            template: defaultFeed,
          );
          await launchBrowserTab(sharUrl, popupOpen: true);
        } catch (error) {
          print('카카오톡 공유 실패 $error');
        }
      }
    } catch (error) {
      print('카카오톡 공유 실패: $error');
    }
  }
}
