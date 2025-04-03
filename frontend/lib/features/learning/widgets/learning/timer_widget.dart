import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final int seconds;

  const TimerWidget({super.key, required this.seconds});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 16,
      child: Text(
        '$seconds',
        style: const TextStyle(
          fontSize: 40, 
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [
            Shadow(
              blurRadius: 5.0,
              color: Colors.black,
              offset: Offset(1.0, 1.0),
            ),
          ],
        ),
      ),
    );
  }
}
