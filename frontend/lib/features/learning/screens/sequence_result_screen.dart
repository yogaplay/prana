import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/learning/models/pose_result.dart';
import 'package:frontend/features/learning/models/sequence_result_response.dart';
import 'package:frontend/features/learning/providers/sequence_result_provider.dart';
import 'package:frontend/features/learning/services/image_upload_service.dart';
import 'package:frontend/features/learning/widgets/result/completed_sequence_banner.dart';
import 'package:frontend/features/learning/widgets/result/congratulations_message.dart';
import 'package:frontend/features/learning/widgets/result/instability_summary_section.dart';
import 'package:frontend/features/learning/widgets/result/pose_result_summary_section.dart';
import 'package:frontend/features/learning/widgets/result/recommended_sequences_accordion.dart';
import 'package:frontend/features/learning/widgets/result/stat_card.dart';
import 'package:frontend/features/search/models/yoga_item.dart';
import 'package:frontend/widgets/button.dart' as custom;
import 'package:frontend/widgets/confetti_overlay.dart';
import 'package:go_router/go_router.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';
import 'package:screenshot/screenshot.dart';

class SequenceResultScreen extends ConsumerStatefulWidget {
  final int userSequenceId;
  final int sequenceId;

  SequenceResultScreen({
    super.key,
    required this.userSequenceId,
    required this.sequenceId,
  });

  @override
  ConsumerState<SequenceResultScreen> createState() =>
      _SequenceResultScreenState();
}

class _SequenceResultScreenState extends ConsumerState<SequenceResultScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isUploading = false;
  String? _sharedImageUrl;

  Future<void> _handleShare(SequenceResultResponse result) async {
    print('handleShare 시작');

    setState(() => _isUploading = true);
    try {
      final Uint8List? image = await _screenshotController.capture();
      if (image == null) return;
      print('스크린샷 캡처 완료');

      final imageUploadService = ref.read(imageUploadServiceProvider);
      final url = await imageUploadService.uploadImage(image);
      if (url == null) return;
      final fileName = Uri.parse(url).pathSegments.last;
      print('파일명 $fileName');
      final viewUrl = 'https://prana.yoplay.kr/share/$fileName';
      print('링크 url: $viewUrl');

      setState(() {
        _sharedImageUrl = url;
        _isUploading = false;
      });

      final template = FeedTemplate(
        content: Content(
          title: '${result.sequenceName} 완료!',
          description: '방금 ${result.sequenceName}을(를) 완료했어요. 함께 해보세요!',
          imageUrl: Uri.parse(url),
          link: Link(
            webUrl: Uri.parse(viewUrl),
            mobileWebUrl: Uri.parse(viewUrl),
          ),
        ),
        buttons: [
          Button(
            title: '자세히 보기',
            link: Link(
              webUrl: Uri.parse(viewUrl),
              mobileWebUrl: Uri.parse(viewUrl),
            ),
          ),
        ],
      );

      if (await ShareClient.instance.isKakaoTalkSharingAvailable()) {
        final uri = await ShareClient.instance.shareDefault(template: template);
        await ShareClient.instance.launchKakaoTalk(uri);
      } else {
        final sharUrl = await WebSharerClient.instance.makeDefaultUrl(
          template: template,
        );
        await launchBrowserTab(sharUrl, popupOpen: true);
      }
    } catch (e) {
      print('공유 중 에러: $e');
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sequenceResultAsync = ref.watch(
      sequenceResultProvider((widget.userSequenceId, widget.sequenceId)),
    );

    return Scaffold(
      body: sequenceResultAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('에러 발생: $error')),
        data: (result) => _buildResultBody(context, result),
      ),
    );
  }

  Widget _buildResultBody(BuildContext context, SequenceResultResponse result) {
    return SafeArea(
      child: Stack(
        children: [
          Screenshot(
            controller: _screenshotController,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
              children: [
                CongratulationsMessage(),
                CompletedSequenceBanner(
                  sequenceName: result.sequenceName,
                  onSharePressed: () {
                    print('공유 버튼 누름 2');
                    _handleShare(result);
                  },
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: StatCard(
                        label: '운동 시간',
                        value: '${result.yogaTime}분',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        label: '완료 동작',
                        value: '${result.sequenceCnt}',
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        label: '정확도',
                        value: '${result.totalAccuracy}%',
                        showInfoIcon: true,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                InstabilitySummarySection(
                  feedbackCounts: {
                    for (final item in result.totalFeedback)
                      item.position: item.feedbackCnt,
                  },
                ),
                SizedBox(height: 16),
                RecommendedSequencesAccordion(
                  bodyF: result.bodyF,
                  bodyS: result.bodyS,
                  sequencesF:
                      result.recommendSequenceF.map((r) {
                        return YogaItem(
                          id: r.sequenceId,
                          title: r.sequenceName,
                          duration: '${(r.sequenceTime / 60).round()}분',
                          imageUrl: r.sequenceImage,
                        );
                      }).toList(),
                  sequencesS:
                      result.recommendSequenceS.map((r) {
                        return YogaItem(
                          id: r.sequenceId,
                          title: r.sequenceName,
                          duration: '${(r.sequenceTime / 60).round()}분',
                          imageUrl: r.sequenceImage,
                        );
                      }).toList(),
                ),
                SizedBox(height: 16),
                PoseResultSummarySection(
                  results:
                      result.positionAccuracy.map((p) {
                        return PoseResult(
                          imageUrl: p.image,
                          poseName: p.yogaName,
                          accuracy: p.accuracy,
                          feedbacks:
                              p.feedback
                                  .map(
                                    (f) => PoseFeedbackItem(
                                      feedback: f.feedback,
                                      feedbackCnt: f.feedbackCnt,
                                    ),
                                  )
                                  .toList(),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
          const ConfettiOverlay(),
          _buildBottomButton(context),
        ],
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 60,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(0, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            color: const Color.fromARGB(255, 255, 255, 255),
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              children: [
                custom.Button(
                  text: '종료',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    GoRouter.of(context).go('/activity');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
