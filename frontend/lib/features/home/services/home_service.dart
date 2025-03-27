import 'package:frontend/core/api/api_client.dart';
import '../models/home_model.dart'; 

class HomeService {
  final ApiClient _apiClient;
  
  HomeService(this._apiClient);
  
  Future<ReportResponse> fetchHomeData() async {
    try {
      final response = await _apiClient.get('/home');
      return ReportResponse.fromJson(response);
    } catch (e) {
      print('홈 데이터 불러오기 실패: $e');
      throw Exception('홈 데이터를 불러오는데 실패했습니다.');
    }
  }

  Future<PaginatedSequenceResponse> fetchDetailItems(String title) async {
  try {
    String endpoint = title == '최근'
        ? '/home/recent'
        : title == '즐겨찾기'
            ? '/home/star'
            : '';

    if (endpoint.isEmpty) throw Exception('잘못된 요청입니다.');

    final response = await _apiClient.get(endpoint);

    return PaginatedSequenceResponse.fromJson(response);
  } catch (e) {
    print('Detail 항목 불러오기 실패: $e');
    throw Exception('Detail 데이터를 불러오는데 실패했습니다.');
  }
}

}