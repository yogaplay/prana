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
}