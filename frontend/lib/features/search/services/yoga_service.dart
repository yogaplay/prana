import 'dart:convert';

import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/search/models/yoga_category.dart';
import 'package:http/http.dart' as http;

class YogaService {
  static const String _baseUrl = 'https://j12a103.p.ssafy.io:8444/api/look';

  static Future<List<YogaCategory>> fetchMainYogaCategories({
    int sampleSize = 3,
  }) async {
    final token = await AuthService().getAccessToken();

    if (token == null) {
      throw Exception('엑세스 토큰이 존재하지 않습니다.');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl?sambleSize=$sampleSize'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      return (data as List).map((item) => YogaCategory.fromJson(item)).toList();
    } else {
      throw Exception('요가 데이터를 불러오는 데 실패하였습니다: ${response.statusCode}');
    }
  }
}
