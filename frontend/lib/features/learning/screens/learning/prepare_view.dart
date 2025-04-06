import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';

class PrepareView extends ConsumerStatefulWidget {
  final VoidCallback onPrepareComplete;

  const PrepareView({Key? key, required this.onPrepareComplete})
    : super(key: key);

  @override
  ConsumerState<PrepareView> createState() => _PrepareViewState();
}

class _PrepareViewState extends ConsumerState<PrepareView> {
  int _countdown = 5;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;

      setState(() {
        _countdown--;
      });


      if (_countdown > 0) {
        // 아직 카운트다운 중이면 재귀 호출
        _startCountdown();
      } else {
        // 준비 시간 종료, 실습 모드로 전환
        widget.onPrepareComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6), // 반투명 어두운 오버레이
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '준비하세요',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '$_countdown',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 80,
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
