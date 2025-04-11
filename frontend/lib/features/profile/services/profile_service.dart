import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/profile/models/profile_model.dart';

class ProfileService {
  final ApiClient _apiClient;

  ProfileService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<ProfileModel> getProfile() async {
    try {
      final response = await _apiClient.get('/user');
      return ProfileModel.fromJson(response);
    } catch (e) {
      print("회원정보 불러오는 중 오류 발생 : $e");
      rethrow;
    }
  }

  Future<ProfileModel> updateProfile(ProfileModel profile) async {
    try {
      final response = await _apiClient.put('/user', body: profile.toJson());
      return ProfileModel.fromJson(response);
    } catch (e) {
      print("회원정보 수정 중 오류 발생 : $e");
      rethrow;
    }
  }
}
