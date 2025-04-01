import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class FeedbackDot extends StatelessWidget {
  final Offset position;
  final Size size;

  const FeedbackDot({super.key, required this.position, required this.size});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: AppColors.secondary.withAlpha((0.8 * 255).toInt()),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
