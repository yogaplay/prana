import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/music_provider.dart';
import 'package:frontend/features/music/models/music_model.dart';
import 'package:just_audio/just_audio.dart';

class MusicSelectionScreen extends ConsumerStatefulWidget {
  const MusicSelectionScreen({super.key});

  @override
  ConsumerState<MusicSelectionScreen> createState() =>
      _MusicSelectionScreenState();
}

class _MusicSelectionScreenState extends ConsumerState<MusicSelectionScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // 화면 로드 시 선택된 음악 정보 가져오기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(playingMusicIdProvider.notifier).state = null; // 초기화
      ref.read(selectedMusicFutureProvider);
    });
  }

  @override
  void dispose() {
    _audioPlayer.stop(); // 음악도 정지
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playMusic(MusicModel music) async {
    final playingMusicId = ref.read(playingMusicIdProvider);

    // 현재 재생 중인 음악이 있으면 정지
    if (playingMusicId != null) {
      await _audioPlayer.stop();

      // 같은 음악을 다시 클릭한 경우 재생 중지 후 종료
      if (playingMusicId == music.musicId) {
        ref.read(playingMusicIdProvider.notifier).state = null;
        return;
      }
    }

    // 새 음악 재생
    try {
      await _audioPlayer.setUrl(music.musicLocation);
      ref.read(playingMusicIdProvider.notifier).state = music.musicId;
      await _audioPlayer.play();
    } catch (e) {
      print('음악 재생 오류: $e');
    }
  }

  void _selectMusic(MusicModel music) async {
    // 음악 선택 함수 호출
    final selectMusic = ref.read(selectMusicProvider);
    await selectMusic(music.musicId);
  }

  @override
  Widget build(BuildContext context) {
    // 음악 목록 데이터 가져오기
    final musicListAsync = ref.watch(musicListFutureProvider);
    // 선택된 음악 데이터 가져오기
    final selectedMusicAsync = ref.watch(selectedMusicFutureProvider);
    // 현재 재생 중인 음악 ID
    final playingMusicId = ref.watch(playingMusicIdProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          titleSpacing: 0,
          toolbarHeight: 80,
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            padding: EdgeInsets.only(left: 25),
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.blackText,
              size: 24,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: const Text(
              '배경음악 선택',
              style: TextStyle(
                color: AppColors.blackText,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            color: AppColors.background,
            child: musicListAsync.when(
              data: (musicList) {
                // 선택된 음악 ID 가져오기
                int? selectedMusicId;
                selectedMusicAsync.whenData((selectedMusic) {
                  if (selectedMusic != null) {
                    selectedMusicId = selectedMusic.musicId;
                    // 로컬 상태 업데이트
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ref.read(selectedMusicIdProvider.notifier).state =
                          selectedMusicId;
                    });
                  }
                });

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: musicList.length,
                  separatorBuilder:
                      (context, index) => const Divider(
                        color: AppColors.lightGray,
                        height: 1,
                        thickness: 1,
                      ),
                  itemBuilder: (context, index) {
                    final music = musicList[index];
                    final isSelected = selectedMusicId == music.musicId;
                    final isPlaying = playingMusicId == music.musicId;

                    return Container(
                      decoration: BoxDecoration(color: AppColors.boxWhite),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading:
                            isSelected
                                ? const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                  size: 28,
                                )
                                : const SizedBox(width: 28),
                        title: Text(
                          music.name,
                          style: const TextStyle(
                            color: AppColors.blackText,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_circle_filled
                                : Icons.play_circle_filled,
                            color: AppColors.graytext,
                            size: 36,
                          ),
                          onPressed: () => _playMusic(music),
                        ),
                        onTap: () => _selectMusic(music),
                      ),
                    );
                  },
                );
              },
              loading:
                  () => const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
              error:
                  (error, stack) => Center(
                    child: Text(
                      '음악 목록을 불러오는 중 오류가 발생했습니다.\n$error',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
