import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/music/models/music_model.dart';

class MusicService {
  final ApiClient _apiClient;

  MusicService({required ApiClient apiClient}) : _apiClient = apiClient;

  // 1. 음악 전체 조회
  Future<List<MusicModel>> getMusicList() async {
    try {
      final response = await _apiClient.get('/music/list');
      final List<dynamic> musicList = response['result'];
      return musicList.map((json) => MusicModel.fromJson(json)).toList();
    } catch (e) {
      print("음악 목록 불러오는 중 오류 발생: $e");
      rethrow;
    }
  }

  // 2. 내가 선택한 음악 조회
  Future<MusicModel?> getSelectedMusic() async {
    try {
      final response = await _apiClient.get('/music');
      if (response == null) return null;
      return MusicModel.fromJson(response);
    } catch (e) {
      print("선택된 음악 불러오는 중 오류 발생: $e");
      rethrow;
    }
  }

  // 3. 음악 선택하기
  Future<void> selectMusic(int musicId) async {
    try {
      await _apiClient.post('/music', body: {'musicId': musicId});
    } catch (e) {
      print("음악 선택 중 오류 발생: $e");
      rethrow;
    }
  }
}
