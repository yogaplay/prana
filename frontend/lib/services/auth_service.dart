import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'dart:convert';

class AuthResponse {
  final String pranaAccessToken;
  final String pranaRefreshToken;
  final bool isFirst;

  AuthResponse({
    required this.pranaAccessToken,
    required this.pranaRefreshToken,
    required this.isFirst,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      pranaAccessToken: json['pranaAccessToken'],
      pranaRefreshToken: json['pranaRefreshToken'],
      isFirst: json['isFirst'],
    );
  }
}

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // 카카오 로그인
  Future<OAuthToken> startWithKakao() async {
    try {
      bool isInstalled = await isKakaoTalkInstalled();

      if (isInstalled) {
        try {
          return await UserApi.instance.loginWithKakaoTalk();
        } catch (error) {
          return await UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        return await UserApi.instance.loginWithKakaoAccount();
      }
    } catch (error) {
      rethrow;
    }
  }

  // 백엔드 서버로 카카오 토큰 전송 -> 프란 서비스 토큰 받아오기
  Future<AuthResponse> getAuthTokens(String kakaoToken) async {
    final response = await http.post(
      Uri.parse('https://j12a103.p.ssafy.io:8444/api/token/generate'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'kakaoAccessToken': kakaoToken}),
    );
    print('서버 응답 상태 코드: ${response.statusCode}');
    print('서버 응답 본문: ${response.body}');
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return AuthResponse.fromJson(responseData);
    } else {
      throw Exception('인증 토큰 발급 실패 ${response.statusCode}');
    }
  }
}
