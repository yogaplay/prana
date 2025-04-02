import 'package:flutter/material.dart';

class CongratulationsMessage extends StatelessWidget {
  const CongratulationsMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Text(
        '축하합니다! 😆',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
