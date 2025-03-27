import 'dart:convert';
import 'package:http/http.dart' as http;

typedef TokenRefreshCallback = Future<String?> Function([bool forceLogout]);

class ApiClient {
  final String baseUrl;
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  TokenRefreshCallback? _tokenRefreshCallback;
  bool _isRefreshing = false;

  ApiClient({this.baseUrl = 'https://j12a103.p.ssafy.io:8444/api'});

  void setTokenRefreshCallback(TokenRefreshCallback callback) {
    _tokenRefreshCallback = callback;
  }

  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _headers.remove('Authorization');
  }

  Future<Map<String, dynamic>> get(String path) async {
    return _executeRequest(
      () => http.get(Uri.parse('$baseUrl$path'), headers: _headers),
    );
  }

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    return _executeRequest(
      () => http.post(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: json.encode(body),
      ),
    );
  }

  Future<Map<String, dynamic>> put(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    return _executeRequest(
      () => http.put(
        Uri.parse('$baseUrl$path'),
        headers: _headers,
        body: json.encode(body),
      ),
    );
  }

  Future<Map<String, dynamic>> delete(String path) async {
    return _executeRequest(
      () => http.delete(Uri.parse('$baseUrl$path'), headers: _headers),
    );
  }

  Future<Map<String, dynamic>> _executeRequest(
    Future<http.Response> Function() requestFunc,
  ) async {
    try {
      final response = await requestFunc();
      return await _handleResponse(response, requestFunc);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> _handleResponse(
    http.Response response,
    Future<http.Response> Function() retryRequest,
  ) async {
    final body = utf8.decode(response.bodyBytes);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body.isEmpty) {
        return {};
      }
      return json.decode(body);
    } else if (response.statusCode == 401) {
      print('401 Unauthorized 발생 - 응답 바디: ${utf8.decode(response.bodyBytes)}');

      final errorBody = json.decode(body);
      final errorCode = errorBody['errorCode'];

      if (errorCode == 40111) {
        print('리프레시 토큰이 유효하지 않음. 로그아웃 처리');

        // 로그아웃 처리
        if (_tokenRefreshCallback != null) {
          await _tokenRefreshCallback!(true); // 강제 로그아웃
        }

        clearAuthToken();

        throw Exception('로그인이 만료되었습니다. 다시 로그인해주세요.');
      }

      if (_tokenRefreshCallback != null && !_isRefreshing) {
        _isRefreshing = true;

        try {
          print("토큰 갱신 시도");
          final newToken = await _tokenRefreshCallback!(false);

          if (newToken != null) {
            setAuthToken(newToken);
            _isRefreshing = false;
            print("요청 재시도");

            final retryResponse = await retryRequest();
            return _handleResponse(retryResponse, retryRequest);
          } else {
            _isRefreshing = false;
            throw Exception("토큰 갱신 실패");
          }
        } catch (e) {
          _isRefreshing = false;
          print("토큰 갱신 실패 : $e");
          throw Exception("토큰 갱신 실패: ${e.toString()}");
        }
      }
      throw Exception('인증에 실패했습니다');
    } else if (response.statusCode == 404) {
      throw Exception('요청한 리소스를 찾을 수 없습니다');
    } else if (response.statusCode >= 500) {
      throw Exception('서버 오류가 발생했습니다');
    } else {
      try {
        final decodedBody = json.decode(body);
        final message = decodedBody['message'] ?? '알 수 없는 오류가 발생했습니다';
        throw Exception(message);
      } catch (_) {
        throw Exception('알 수 없는 오류가 발생했습니다 (코드: ${response.statusCode})');
      }
    }
  }

  Exception _handleError(dynamic error) {
    print('API 에러 발생: $error');

    if (error is http.ClientException) {
      if (error.message.contains('Connection refused') ||
          error.message.contains('Connection reset')) {
        return Exception('서버에 연결할 수 없습니다');
      }
      if (error.message.contains('timed out')) {
        return Exception('서버 응답 시간이 초과되었습니다');
      }
    }

    if (error is Exception) {
      return error;
    }

    return Exception('알 수 없는 오류가 발생했습니다: ${error.toString()}');
  }
}
