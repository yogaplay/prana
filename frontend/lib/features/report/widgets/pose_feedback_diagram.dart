import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/report/models/body_feedback.dart';
import 'package:frontend/features/report/models/body_part.dart';
import 'package:frontend/features/report/widgets/FeedbackSummaryText.dart';

class BodyFeedbackLayout {
  final Offset center;
  final double radius;

  BodyFeedbackLayout({required this.center, required this.radius});

  Size get size => Size(radius * 2, radius * 2);
  Offset get topLeft => Offset(center.dx - radius, center.dy - radius);
}

Map<String, BodyFeedbackLayout> partLayoutMap = {
  'left_shoulder': BodyFeedbackLayout(center: Offset(120, 70), radius: 15),
  'right_shoulder': BodyFeedbackLayout(center: Offset(70, 70), radius: 15),
  'elbow_left': BodyFeedbackLayout(center: Offset(90, 120), radius: 11),
  'elbow_right': BodyFeedbackLayout(center: Offset(190, 120), radius: 11),
  'arm_left': BodyFeedbackLayout(center: Offset(75, 150), radius: 10),
  'arm_right': BodyFeedbackLayout(center: Offset(205, 150), radius: 10),
  'hip_left': BodyFeedbackLayout(center: Offset(120, 200), radius: 13),
  'hip_right': BodyFeedbackLayout(center: Offset(160, 200), radius: 13),
  'knee_left': BodyFeedbackLayout(center: Offset(110, 260), radius: 12),
  'knee_right': BodyFeedbackLayout(center: Offset(170, 260), radius: 12),
  'leg_left': BodyFeedbackLayout(center: Offset(100, 310), radius: 10),
  'leg_right': BodyFeedbackLayout(center: Offset(180, 310), radius: 10),
};

class PoseFeedbackDiagram extends StatelessWidget {
  final bool isMale;
  final Map<String, int> partCounts;

  const PoseFeedbackDiagram({
    super.key,
    this.isMale = true,
    required this.partCounts,
  });

  @override
  Widget build(BuildContext context) {
    final feedbacks = [
      {"position": "back", "count": 30},
      {"position": "arm", "count": 15},
      {"position": "leg", "count": 1},
      {"position": "core", "count": 0},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FeedbackSummarytext(feedbacks: feedbacks),
        SizedBox(height: 24),
        Center(
          child: SizedBox(
            height: 400,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Image.asset(
                  isMale
                      ? 'assets/images/man-body.png'
                      : 'assets/images/woman-body.png',
                  fit: BoxFit.contain,
                ),
                ..._buildFeedbackWidgets(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildFeedbackWidgets() {
    return partCounts.entries.where((e) => e.value > 0).map((entry) {
      final layout = partLayoutMap[entry.key]!;
      return Positioned(
        left: layout.topLeft.dx,
        top: layout.topLeft.dy,
        child: _FeedbackCircle(count: entry.value, radius: layout.radius),
      );
    }).toList();
  }
}

class _FeedbackCircle extends StatefulWidget {
  final int count;
  final double radius;

  const _FeedbackCircle({required this.count, required this.radius});

  @override
  State<_FeedbackCircle> createState() => __FeedbackCircleState();
}

class __FeedbackCircleState extends State<_FeedbackCircle> {
  bool _show = false;
  void _setShow(bool value) => setState(() {
    _show = value;
  });

  @override
  Widget build(BuildContext context) {
    final double size = widget.radius * 2;

    return GestureDetector(
      onTapDown: (details) => _setShow(true),
      onTapUp: (details) => _setShow(false),
      onTapCancel: () => _setShow(false),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: AppColors.secondary.withAlpha((0.8 * 255).toInt()),
              shape: BoxShape.circle,
            ),
          ),
          if (_show)
            Positioned(
              top: -widget.radius - 28,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.blackText,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${widget.count}회',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
