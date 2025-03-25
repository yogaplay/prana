import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/home_model.dart'; // 아래에서 만들 모델 파일

class HomeService {
  static Future<ReportResponse> fetchHomeData({
    required String token, 
  }) async {
    final url = Uri.parse('https://j12a103.p.ssafy.io:8444/api/home');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // ✅ 꼭 Bearer 붙이기
    };
    print('사용 중인 토큰: $token');
    print('요청 URL: $url');
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return ReportResponse.fromJson(jsonData);
    } else {
      throw Exception('홈 데이터 불러오기 실패: ${response.statusCode}');
    }
  }
}