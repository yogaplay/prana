import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/profile/models/profile_model.dart';
import 'package:frontend/features/profile/services/profile_service.dart';

final profileServiceProvider = Provider<ProfileService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProfileService(apiClient: apiClient);
});

final profileProvider = FutureProvider<ProfileModel>((ref) async {
  final isLoggedIn = await ref.watch(authStateProvider.future);
  if (!isLoggedIn) {
    throw Exception('로그인이 필요합니다');
  }

  final profileService = ref.read(profileServiceProvider);
  return profileService.getProfile();
});

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, AsyncValue<ProfileModel?>>((ref) {
      final profileService = ref.watch(profileServiceProvider);
      return ProfileNotifier(profileService);
    });

class ProfileNotifier extends StateNotifier<AsyncValue<ProfileModel?>> {
  final ProfileService _profileService;

  ProfileNotifier(this._profileService) : super(const AsyncValue.loading()) {
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final profile = await _profileService.getProfile();

      if (mounted) {
        state = AsyncValue.data(profile);
      }
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
    }
  }

  Future<bool> updateProfile(ProfileModel updatedProfile) async {
    try {
      final profile = await _profileService.updateProfile(updatedProfile);

      if (mounted) {
        state = AsyncValue.data(profile);
      }
      return true;
    } catch (error, stackTrace) {
      if (mounted) {
        state = AsyncValue.error(error, stackTrace);
      }
      return false;
    }
  }

  Future<bool> updateNickname(String nickname) async {
    if (state.value == null) return false;

    final currentProfile = state.value!;
    final updatedProfile = currentProfile.copyWith(nickname: nickname);

    return updateProfile(updatedProfile);
  }

  Future<bool> updateHeight(int height) async {
    if (state.value == null) return false;

    final currentProfile = state.value!;
    final updatedProfile = currentProfile.copyWith(height: height);

    return updateProfile(updatedProfile);
  }

  Future<bool> updateAge(int age) async {
    if (state.value == null) return false;

    final currentProfile = state.value!;
    final updatedProfile = currentProfile.copyWith(age: age);

    return updateProfile(updatedProfile);
  }

  Future<bool> updateWeight(int weight) async {
    if (state.value == null) return false;

    final currentProfile = state.value!;
    final updatedProfile = currentProfile.copyWith(weight: weight);

    return updateProfile(updatedProfile);
  }

  Future<bool> updateGender(String gender) async {
    if (state.value == null) return false;

    final currentProfile = state.value!;
    final updatedProfile = currentProfile.copyWith(gender: gender);

    return updateProfile(updatedProfile);
  }
}
