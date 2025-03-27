import 'package:frontend/core/api/api_client.dart';
import '../models/home_model.dart'; 

class HomeService {
  final ApiClient _apiClient;
  
  HomeService(this._apiClient);
  
  Future<ReportResponse> fetchHomeData() async {
    try {
      final response = await _apiClient.get('/home');
      print(response);
      return ReportResponse.fromJson(response);
    } catch (e) {
      print('홈 데이터 불러오기 실패: $e');
      throw Exception('홈 데이터를 불러오는데 실패했습니다.');
    }
  }

  Future<PaginatedSequenceResponse> fetchDetailItems(String title, {int page = 0, int size = 10}) async {
    try {
      String endpoint = title == '최근'
          ? '/home/recent'
          : title == '즐겨찾기'
              ? '/home/star'
              : '';
      print(endpoint);

      if (endpoint.isEmpty) throw Exception('잘못된 요청입니다.');

      final response = await _apiClient.get('$endpoint?page=$page&size=$size',);
      print(response);
      return PaginatedSequenceResponse.fromJson(response);
    } catch (e) {
      print('Detail 항목 불러오기 실패: $e');
      throw Exception('Detail 데이터를 불러오는데 실패했습니다.');
    }
  }

  Future<void> toggleStar(int sequenceId) async {
    try {
      await _apiClient.post(
        '/home/star',
        body: {'sequenceId': sequenceId},
      );
    } catch (e) {
      print('즐겨찾기 토글 실패: $e');
      throw Exception('즐겨찾기 변경에 실패했습니다.');
    }
  }
}