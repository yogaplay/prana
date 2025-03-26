import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/report/models/body_feedback.dart';
import 'package:frontend/features/report/models/body_part.dart';

// 피드백 레이아웃 정보 클래스
class BodyFeedbackLayout {
  final Offset centerPosition;
  final Size shapeSize;
  final Offset lineStart;
  final Offset lineEnd;
  final Offset textPosition;

  const BodyFeedbackLayout({
    required this.centerPosition,
    required this.shapeSize,
    required this.lineStart,
    required this.lineEnd,
    required this.textPosition,
  });
}

// 부위별 레이아웃 정보 맵
const Map<BodyPart, BodyFeedbackLayout> feedbackLayoutMap = {
  BodyPart.shoulder: BodyFeedbackLayout(
    centerPosition: Offset(120, 80),
    shapeSize: Size(40, 30),
    lineStart: Offset(140, 95),
    lineEnd: Offset(60, 60),
    textPosition: Offset(30, 40),
  ),
  BodyPart.arm: BodyFeedbackLayout(
    centerPosition: Offset(180, 140),
    shapeSize: Size(30, 30),
    lineStart: Offset(195, 155),
    lineEnd: Offset(230, 155),
    textPosition: Offset(30, 145),
  ),
  BodyPart.leg: BodyFeedbackLayout(
    centerPosition: Offset(140, 250),
    shapeSize: Size(35, 35),
    lineStart: Offset(155, 270),
    lineEnd: Offset(100, 300),
    textPosition: Offset(75, 290),
  ),
  BodyPart.core: BodyFeedbackLayout(
    centerPosition: Offset(110, 180),
    shapeSize: Size(60, 40),
    lineStart: Offset(130, 200),
    lineEnd: Offset(90, 220),
    textPosition: Offset(65, 210),
  ),
};

class LinePainter extends CustomPainter {
  final Offset from;
  final Offset to;

  LinePainter({required this.from, required this.to});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.secondary
          ..strokeWidth = 1.5;

    canvas.drawLine(from, to, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class PoseFeedbackDiagram extends StatelessWidget {
  final bool isMale;
  final List<BodyFeedback> bodyFeedback;

  const PoseFeedbackDiagram({
    super.key,
    this.isMale = true,
    required this.bodyFeedback,
  });

  @override
  Widget build(BuildContext context) {
    String buildPartFeedbackText(List<BodyFeedback> list) {
      final parts = list.map((f) => f.part.name).toList();

      if (parts.isEmpty) return '';

      if (parts.length == 1) {
        return parts[0];
      }

      final commaParts = parts.sublist(0, parts.length - 1).join(', ');
      return '$commaParts, ${parts.last}';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이번 주의 피드백',
          style: TextStyle(fontSize: 16, color: AppColors.blackText),
        ),
        SizedBox(height: 8),
        bodyFeedback.isNotEmpty
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buildPartFeedbackText(bodyFeedback),
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.blackText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '에서 불안정한 자세가 보였습니다.',
                  style: TextStyle(fontSize: 16, color: AppColors.blackText),
                ),
              ],
            )
            : Text('이번주는 완벽했어요!'),
        SizedBox(height: 24),
        Center(
          child: SizedBox(
            height: 400,
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.asset(
                    isMale
                        ? 'assets/images/man-body.png'
                        : 'assets/images/woman-body.png',
                    fit: BoxFit.contain,
                  ),
                  ...bodyFeedback.expand((data) {
                    final layout = feedbackLayoutMap[data.part]!;
                    final shapeTopLeft = Offset(
                      layout.centerPosition.dx - layout.shapeSize.width / 2,
                      layout.centerPosition.dy - layout.shapeSize.height / 2,
                    );

                    return [
                      Positioned(
                        left: shapeTopLeft.dx,
                        top: shapeTopLeft.dy,
                        child: Container(
                          width: layout.shapeSize.width,
                          height: layout.shapeSize.height,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withAlpha(
                              (0.8 * 255).toInt(),
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.elliptical(
                                layout.shapeSize.width,
                                layout.shapeSize.height,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: layout.lineStart.dx,
                        top: layout.lineStart.dy,
                        child: CustomPaint(
                          painter: LinePainter(
                            from: Offset.zero,
                            to: layout.lineEnd - layout.lineStart,
                          ),
                        ),
                      ),
                      Positioned(
                        left: layout.textPosition.dx,
                        top: layout.textPosition.dy,
                        child: Text(
                          '${data.count}회',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ];
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
