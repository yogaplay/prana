import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/features/learning/providers/learning_providers.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class TutorialView extends ConsumerStatefulWidget {
  final int sequenceId;
  const TutorialView({super.key, required this.sequenceId});

  @override
  ConsumerState<TutorialView> createState() => _TutorialViewState();
}

class _TutorialViewState extends ConsumerState<TutorialView> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    final currentIndex = ref.read(currentYogaIndexProvider);
    print('튜토리얼 시작: 요가 동작 인덱스 $currentIndex');

    ref.read(learningStateProvider.notifier).state = LearningState.tutorial;
    _initializeController();
  }

  Future<void> _initializeController() async {
    final currentYoga = ref.read(currentYogaProvider);
    if (currentYoga != null) {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(currentYoga.video),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      await _controller.initialize();

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });

        // 영상의 오디오는 음소거
        _controller.setVolume(0.0);
        // 자동 재생 시작
        _controller.play();

        _controller.addListener(_videoListener);
      }
    }
  }

  void _videoListener() {
    if (_controller.value.position >= _controller.value.duration) {
      final currentIndex = ref.read(currentYogaIndexProvider);
      print('튜토리얼 완료: 요가 동작 인덱스 $currentIndex, 연습 모드로 전환');

      if (ref.read(learningStateProvider) == LearningState.tutorial) {
        ref.read(learningStateProvider.notifier).state = LearningState.preparing;
      }
    }
    setState(() {});
  }

  void _skipTutorial() {
    ref.read(learningStateProvider.notifier).state = LearningState.preparing;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackText,
      body: GestureDetector(
        child: Stack(
          children: [
            Center(
              child:
                  _isInitialized
                      ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                      : const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
            ),

            if (_isInitialized)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: LinearProgressIndicator(
                  value:
                      _controller.value.duration.inSeconds > 0
                          ? _controller.value.position.inSeconds /
                              _controller.value.duration.inSeconds
                          : 0.0,
                  backgroundColor: Colors.black.withAlpha(179),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                  minHeight: 5,
                ),
              ),

            if (_isInitialized)
              if (_isInitialized)
                Positioned(
                  right: 30,
                  bottom: 30,
                  child: GestureDetector(
                    onTap: _skipTutorial,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.skip_next, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 컨트롤 타이머 제거
    _timer?.cancel();
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }
}
