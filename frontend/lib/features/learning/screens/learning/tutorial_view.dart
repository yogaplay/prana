import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:video_player/video_player.dart';

class TutorialView extends ConsumerStatefulWidget {
  const TutorialView({super.key});

  @override
  ConsumerState<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends ConsumerState<TutorialView> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    ref.read(learningStateProvider.notifier).state = LearningState.tutorial;
    _initializeController();
  }

  Future<void> _initializeController() async {
    final currentYoga = ref.read(currentYogaProvider);
    if (currentYoga != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(currentYoga.video),
      );

      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // 초기화 후 자동 재생
        _controller.play();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackText,
      body: Center(
        child:
            _controller.value.isInitialized
                ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                : const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
