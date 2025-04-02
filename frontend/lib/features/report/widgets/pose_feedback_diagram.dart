import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

enum BodyPart { back, arm, core, leg }

class BodyFeedback {
  final BodyPart part;
  final int count;

  BodyFeedback({required this.part, required this.count});
}

class BodyFeedbackLayout {
  final Offset center;
  final Size size;
  final Offset bend;
  final Offset end;
  final Offset textPosition;

  BodyFeedbackLayout({
    required this.center,
    required this.size,
    required this.bend,
    required this.end,
    required this.textPosition,
  });
}

class PoseFeedbackDiagram extends StatelessWidget {
  final bool isMale;
  final List<BodyFeedback> feedbacks;

  PoseFeedbackDiagram({
    super.key,
    required this.isMale,
    required this.feedbacks,
  });

  final double centerX = 189.7;

  late final Map<BodyPart, BodyFeedbackLayout> layoutMap = {
    BodyPart.back: BodyFeedbackLayout(
      center: Offset(centerX - 40, 100),
      size: Size(28, 28),
      bend: Offset(centerX - 70, 30),
      end: Offset(centerX - 130, 30),
      textPosition: Offset(centerX - 160, 19),
    ),
    BodyPart.arm: BodyFeedbackLayout(
      center: Offset(centerX + 47, 160),
      size: Size(24, 24),
      bend: Offset(centerX + 70, 100),
      end: Offset(centerX + 130, 100),
      textPosition: Offset(centerX + 135, 89),
    ),
    BodyPart.core: BodyFeedbackLayout(
      center: Offset(centerX - 17, 220),
      size: Size(33, 33),
      bend: Offset(centerX - 70, 280),
      end: Offset(centerX - 135, 280),
      textPosition: Offset(centerX - 165, 269),
    ),
    BodyPart.leg: BodyFeedbackLayout(
      center: Offset(centerX + 21, 290),
      size: Size(24, 24),
      bend: Offset(centerX + 70, 346),
      end: Offset(centerX + 130, 346),
      textPosition: Offset(centerX + 135, 335),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: double.infinity,
        height: 420,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                isMale
                    ? 'assets/images/man-body.png'
                    : 'assets/images/woman-body.png',
                fit: BoxFit.contain,
              ),
            ),
            ...feedbacks.where((f) => f.count > 0).map((f) {
              final layout = layoutMap[f.part]!;
              final topLeft = Offset(
                layout.center.dx - layout.size.width / 2,
                layout.center.dy - layout.size.height / 2,
              );
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: topLeft.dx,
                    top: topLeft.dy,
                    child: Container(
                      width: layout.size.width,
                      height: layout.size.height,
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withAlpha(
                          (0.8 * 255).toInt(),
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 0,
                    child: CustomPaint(
                      painter: LinePainter(
                        from: layout.center,
                        bend: layout.bend,
                        to: layout.end,
                      ),
                    ),
                  ),
                  Positioned(
                    left: layout.textPosition.dx,
                    top: layout.textPosition.dy,
                    child: Text(
                      '${f.count}회',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final Offset from;
  final Offset bend;
  final Offset to;

  LinePainter({
    super.repaint,
    required this.from,
    required this.bend,
    required this.to,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = AppColors.primary
          ..strokeWidth = 1.5;

    canvas.drawLine(from, bend, paint);
    canvas.drawLine(bend, to, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
