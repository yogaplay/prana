import 'package:frontend/core/api/api_client.dart';

class SignupService {
  final ApiClient _apiClient;

  SignupService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<void> signUp({
    required String gender,
    required String age,
    required String weight,
    required String height,
  }) async {
    try {
      await _apiClient.post(
        '/user/signup',
        body: {
          'gender': gender,
          'age': age,
          'weight': weight,
          'height': height,
        },
      );

      print("추가정보 저장 성공");
    } catch (e) {
      print("추가정보 저장 실패 ${e.toString()}");
      rethrow;
    }
  }
}
