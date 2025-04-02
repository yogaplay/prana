import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';

class TutorialView extends ConsumerWidget {
  const TutorialView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sequenceDetail = ref.watch(selectedSequenceProvider);
    print("튜토리얼 화면");
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(sequenceDetail!.sequenceImage),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black26, BlendMode.darken),
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2),
              Container(
                alignment: Alignment.center,
                child: Text(
                  '모든 튜토리얼 영상을 스킵할까요?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}
