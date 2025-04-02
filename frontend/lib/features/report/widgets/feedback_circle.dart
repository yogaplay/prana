import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class FeedbackCircle extends StatefulWidget {
  final Offset topLeft;
  final Size size;
  final int count;

  const FeedbackCircle({
    super.key,
    required this.topLeft,
    required this.size,
    required this.count,
  });

  @override
  State<FeedbackCircle> createState() => _FeedbackCircleState();
}

class _FeedbackCircleState extends State<FeedbackCircle> {
  bool _show = false;

  void _setShow(bool value) {
    if (_show != value) {
      setState(() {
        _show = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.topLeft.dx,
      top: widget.topLeft.dy,
      child: GestureDetector(
        onTapDown: (details) => _setShow(true),
        onTapUp: (details) => _setShow(false),
        onTapCancel: () => _setShow(false),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: widget.size.width,
              height: widget.size.height,
              decoration: BoxDecoration(
                color: AppColors.secondary.withAlpha((0.8 * 255).toInt()),
                shape: BoxShape.circle,
              ),
            ),
            if (_show)
              Positioned(
                top: -30,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.blackText,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${widget.count}회',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
