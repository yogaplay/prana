import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/auth/models/auth_model.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthService {
  final ApiClient _apiClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Ref? ref;

  static const String _accessToken = 'prana_access_token';
  static const String _refreshToken = 'prana_refresh_token';
  static const String _isFirst = 'prana_is_first';

  AuthService({required ApiClient apiClient, this.ref})
    : _apiClient = apiClient;

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

  // 서비스 토큰 발급
  Future<AuthResponse> getAuthTokens(String kakaoToken) async {
    try {
      final response = await _apiClient.post(
        '/token/generate',
        body: {'kakaoAccessToken': kakaoToken},
      );

      final authResponse = AuthResponse.fromJson(response);
      await saveAuthData(authResponse);

      return authResponse;
    } catch (e) {
      print('인증 토큰 발급 실패: ${e.toString()}');
      throw Exception('인증 토큰 발급 실패');
    }
  }

  // 토큰 재발급
  Future<RefreshResponse> refreshToken() async {
    String? refreshToken = await getRefreshToken();

    // refreshToken이 null이거나 비어있는 경우 체크
    if (refreshToken == null || refreshToken.isEmpty) {
      print('리프레시 토큰이 없습니다.');
      await logout();
      throw Exception('리프레시 토큰이 없습니다');
    }

    try {
      print("토큰 재발급 시도 - 리프레시 토큰: $refreshToken");

      final response = await _apiClient.post(
        '/token/refresh',
        body: {'pranaRefreshToken': refreshToken},
      );

      print("토큰 재발급 응답: $response");

      final refreshResponse = RefreshResponse.fromJson(response);
      await updateAccessToken(refreshResponse);

      return refreshResponse;
    } catch (e) {
      print('토큰 재발급 실패: ${e.toString()}');
      await logout();
      throw Exception('토큰 재발급 실패');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: _accessToken);
    await _storage.delete(key: _refreshToken);
    await _storage.delete(key: _isFirst);
    _apiClient.clearAuthToken();

    if (ref != null) {
      ref?.invalidate(authStateProvider);
      ref?.invalidate(authStateNotifierProvider);
    }
  }

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessToken, value: token);
    _apiClient.setAuthToken(token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshToken, value: token);
  }

  Future<void> saveAuthData(AuthResponse authResponse) async {
    await _storage.write(
      key: _accessToken,
      value: authResponse.pranaAccessToken,
    );
    await _storage.write(
      key: _refreshToken,
      value: authResponse.pranaRefreshToken,
    );
    await _storage.write(key: _isFirst, value: authResponse.isFirst.toString());

    _apiClient.setAuthToken(authResponse.pranaAccessToken);
  }

  Future updateAccessToken(RefreshResponse response) async {
    await _storage.write(key: _accessToken, value: response.pranaAccessToken);
    _apiClient.setAuthToken(response.pranaAccessToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshToken);
  }

  Future<bool> isFirstLogin() async {
    final isFirst = await _storage.read(key: _isFirst);
    return isFirst == 'true';
  }

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // 앱 시작 시 호출하여 저장된 토큰이 있으면 API 클라이언트에 설정
  Future<void> initializeTokens() async {
    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      _apiClient.setAuthToken(token);
    }
  }
}
