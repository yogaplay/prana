import 'package:frontend/core/api/api_client.dart';

class FavoriteService {
  final ApiClient _apiClient;

  FavoriteService(this._apiClient);

  Future<bool> toggleFavorite(int sequenceId) async {
    try {
      final response = await _apiClient.post(
        '/home/star',
        body: {'sequenceId': sequenceId},
      );
      return response['star'] ?? false;
    } catch (e) {
      print('즐겨찾기 토글 오류: $e');
      rethrow;
    }
  }
}
