import 'dart:convert';

import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:http/http.dart' as http;

class SignupService {
  final AuthService _authService = AuthService();

  Future<void> signUp({
    required String gender,
    required String age,
    required String weight,
    required String height,
  }) async {
    final url = Uri.parse('https://j12a103.p.ssafy.io:8444/api/user/signup');

    try {
      String? token = await _authService.getAccessToken();

      if (token == null) {
        print("토큰 없음");
      }

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'gender': gender,
          'age': age,
          'weight': weight,
          'height': height,
        }),
      );

      if (response.statusCode == 200) {
        print("추가정보 저장 성공!!");
      } else {
        print("추가정보 저장 실패: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("ERROR!! $e");
    }
  }
}
