import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PracticeView extends ConsumerWidget {
  const PracticeView({super.key});

 

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("요가 학습 화면");
    return Scaffold(body: Text('요가 학습 화면 ~_~'));
  }
}
