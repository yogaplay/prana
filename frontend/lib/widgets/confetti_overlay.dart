import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({super.key});

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay> {
  late ConfettiController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.play();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConfettiWidget(
        confettiController: _controller,
        blastDirectionality: BlastDirectionality.explosive,
        blastDirection: -pi / 2,
        emissionFrequency: 0.003,
        numberOfParticles: 100,
        maxBlastForce: 20,
        minBlastForce: 13,
        gravity: 0.03,
        shouldLoop: false,
        colors: [
          Colors.pink.shade200,
          Colors.yellow.shade200,
          Colors.blue.shade200,
          AppColors.primary,
        ],
        createParticlePath: _drawRectangle,
        particleDrag: 0.05,
      ),
    );
  }

  Path _drawRectangle(Size size) {
    return Path()..addRect(Rect.fromLTWH(0, 0, 7, 14));
  }
}
