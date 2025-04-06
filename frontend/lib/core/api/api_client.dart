import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/features/auth/services/auth_service.dart';

class ApiClient {
  final String baseUrl;
  late final Dio _dio;
  late AuthService _authService;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _accessToken = 'prana_access_token';

  Future<String?> getStoredToken() async {
    return await _storage.read(key: _accessToken);
  }

  ApiClient({this.baseUrl = 'https://j12a103.p.ssafy.io:8444/api'}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 인터셉터 설정
    _setupInterceptors();
  }

  void setAuthService(AuthService authService) {
    _authService = authService;
  }

  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          return handler.next(options);
        },
        onResponse: (response, handler) {
          return handler.next(response);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final errorCode = e.response?.data?['errorCode'];
            print(e.response);

            if (errorCode == 40111) {
              print('리프레쉬 토큰 유효하지 않음: 로그아웃 처리');
              _authService.logout();
              return handler.next(e);
            }

            if (errorCode == 40112) {
              try {
                print('액세스토큰 유효하지 않음 : 토큰 재발급');
                final authResponse = await _authService.refreshToken();

                if (authResponse.pranaAccessToken.isNotEmpty) {
                  return handler.resolve(await _retry(e.requestOptions));
                }
              } catch (e) {
                print("재요청 중 오류 발생");
                print(e);
                _authService.logout();
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final token = await getStoredToken();

    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $token'},
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  // GET 요청
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // POST 요청
  Future<Map<String, dynamic>> post(
    String path, {
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // PUT 요청
  Future<Map<String, dynamic>> put(
    String path, {
    required Map<String, dynamic> body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE 요청
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> postMultipart(
    String path, {
    required Map<String, dynamic> fields,
    required Map<String, File> files,
  }) async {
    try {
      final formData = FormData();

      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      for (var entry in files.entries) {
        final file = entry.value;
        formData.files.add(
          MapEntry(
            entry.key,
            await MultipartFile.fromFile(
              file.path,
              filename: file.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _dio.post(path, data: formData);

      return _processResponse(response);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Map<String, dynamic> _processResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      if (response.data is Map<String, dynamic>) {
        return response.data;
      } else if (response.data is String) {
        try {
          return {'data': response.data};
        } catch (e) {
          return {'data': response.data};
        }
      } else {
        return {'data': response.data};
      }
    } else {
      throw ApiException(
        message: 'Server error occurred',
        statusCode: response.statusCode,
      );
    }
  }

  // 에러 처리
  Exception _handleError(DioException error) {
    String message = 'Something went wrong';
    int? statusCode;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.badResponse:
        statusCode = error.response?.statusCode;
        message = error.response?.data?['message'] ?? 'Server error occurred';
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      default:
        message = 'Unexpected error occurred';
        break;
    }

    return ApiException(message: message, statusCode: statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException({required this.message, this.statusCode});

  @override
  String toString() => 'ApiException: $message (Status code: $statusCode)';
}
