import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  ApiClient({this.baseUrl = 'https://j12a103.p.ssafy.io:8444/api'});

  void setAuthToken(String token) {
    _headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _headers.remove('Authorization');
  }

  Future<Map<String, dynamic>> get(String path) async {
    final url = Uri.parse('$baseUrl$path');

    try {
      final response = await http.get(url, headers: _headers);
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('$baseUrl$path');

    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    required Map<String, dynamic> body,
  }) async {
    final url = Uri.parse('$baseUrl$path');

    try {
      final response = await http.put(
        url,
        headers: _headers,
        body: json.encode(body),
      );
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final url = Uri.parse('$baseUrl$path');

    try {
      final response = await http.delete(url, headers: _headers);
      return _processResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    final body = utf8.decode(response.bodyBytes);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (body.isEmpty) {
        return {};
      }
      return json.decode(body);
    } else if (response.statusCode == 401) {
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
