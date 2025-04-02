import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class FeedbackTooltip extends StatefulWidget {
  final Offset position;
  final double offsetY;
  final int count;

  const FeedbackTooltip({
    super.key,
    required this.position,
    required this.offsetY,
    required this.count,
  });

  @override
  State<FeedbackTooltip> createState() => _FeedbackTooltipState();
}

class _FeedbackTooltipState extends State<FeedbackTooltip> {
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
      left: widget.position.dx,
      top: widget.position.dy,
      child: GestureDetector(
        onTapDown: (_) => _setShow(true),
        onTapUp: (_) => _setShow(false),
        onTapCancel: () => _setShow(false),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            SizedBox(width: 20, height: 20),
            if (_show)
              Positioned(
                top: -widget.offsetY,
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
