import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/home_model.dart'; // 아래에서 만들 모델 파일

class HomeService {
  static Future<ReportResponse> fetchHomeData() async {
    final url = Uri.parse('https://j12a103.p.ssafy.io:8444/api/home');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return ReportResponse.fromJson(jsonData);
    } else {
      throw Exception('api/home 요청 실패함');
    }
  }
}