import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';

class TimerWidget extends ConsumerWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seconds = ref.watch(countdownProvider);
    final sequence = ref.watch(selectedSequenceProvider);

    if (sequence == null) return const SizedBox.shrink();

    return Positioned(
      bottom: 40,
      left: 40,
      child: SizedBox(
        width: 150,
        height: 150,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: SvgPicture.asset(
                'assets/images/timer_frame.svg',
                width: 120,
                height: 120,
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              top: 50,
              child: Center(
                child: Text(
                  _formatTime(seconds),
                  style: const TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes > 0) {
      return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '$remainingSeconds';
    }
  }
}
