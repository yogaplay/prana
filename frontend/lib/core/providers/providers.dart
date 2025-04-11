import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/core/providers/auth_provider.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/auth/services/signup_service.dart';
import 'package:frontend/features/home/models/home_model.dart';
import 'package:frontend/features/home/services/home_service.dart';
import 'package:frontend/features/music/services/music_service.dart';

// 기존 Provider들은 그대로 유지
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://j12a103.p.ssafy.io:8444/api');
});

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final authService = AuthService(apiClient: apiClient, ref: ref);

  apiClient.setAuthService(authService);

  return authService;
});

// 기존 FutureProvider는 유지 (호환성을 위해)
final authStateProvider = FutureProvider<bool>((ref) async {
  final authService = ref.read(authServiceProvider);
  return await authService.isLoggedIn();
});

// 새로운 StateNotifierProvider 추가
final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
      final authService = ref.read(authServiceProvider);
      return AuthStateNotifier(authService);
    });

// 간편하게 인증 여부만 확인하는 Provider
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateNotifierProvider);
  return authState.status == AuthStatus.authenticated;
});

// 나머지 Provider들은 그대로 유지
final signupServiceProvider = Provider<SignupService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SignupService(apiClient: apiClient);
});

final isFirstLoginProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return await authService.isFirstLogin();
});

final homeServiceProvider = Provider<HomeService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeService(apiClient);
});

final musicServiceProvider = Provider<MusicService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MusicService(apiClient: apiClient);
});

final homeDataProvider = FutureProvider<ReportResponse>((ref) async {
  // 여기서 authStateProvider 대신 isAuthenticatedProvider를 사용할 수도 있습니다
  final isLoggedIn = await ref.watch(authStateProvider.future);
  if (!isLoggedIn) {
    throw Exception('로그인이 필요합니다');
  }
  final homeService = ref.read(homeServiceProvider);
  return homeService.fetchHomeData();
});

Future<void> initializeApp(WidgetRef ref) async {
  final authService = ref.read(authServiceProvider);
  await authService.initializeTokens();

  ref.read(authStateNotifierProvider);
}
