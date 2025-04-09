import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/learning/providers/sequence_providers.dart';
import 'package:frontend/features/music/models/music_model.dart';

// 음악 목록을 가져오는 FutureProvider
final musicListFutureProvider = FutureProvider<List<MusicModel>>((ref) async {
  final musicService = ref.watch(musicServiceProvider);
  return await musicService.getMusicList();
});

// 선택된 음악을 가져오는 FutureProvider
final selectedMusicFutureProvider = FutureProvider<MusicModel?>((ref) async {
  final musicService = ref.watch(musicServiceProvider);
  return await musicService.getSelectedMusic();
});

// 현재 선택된 음악 ID를 관리하는 StateProvider
final selectedMusicIdProvider = StateProvider<int?>((ref) => null);

// 현재 재생 중인 음악 ID를 관리하는 StateProvider
final playingMusicIdProvider = StateProvider<int?>((ref) => null);

// 음악 선택 기능을 제공하는 Provider
final selectMusicProvider = Provider<Future<void> Function(int)>((ref) {
  final musicService = ref.watch(musicServiceProvider);

  return (int musicId) async {
    // 서버에 음악 선택 요청
    await musicService.selectMusic(musicId);

    // 로컬 상태 업데이트
    ref.read(selectedMusicIdProvider.notifier).state = musicId;

    // 선택된 음악 정보 갱신을 위해 FutureProvider 새로고침
    ref.invalidate(selectedMusicFutureProvider);
    ref.invalidate(sequenceDetailProvider);
  };
});
