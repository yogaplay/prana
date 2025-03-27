import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/auth/services/signup_service.dart';
import 'package:frontend/features/home/models/home_model.dart';
import 'package:frontend/features/home/services/home_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://j12a103.p.ssafy.io:8444/api');
});

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final authService = AuthService(apiClient: apiClient);

  apiClient.setTokenRefreshCallback(([bool forceLogout = false]) async {
    if (forceLogout) {
      print("강제 로그아웃");
      await authService.logout();
      ref.read(authRefreshProvider.notifier).state += 1;
      return null;
    }
    try {
      final authResponse = await authService.refreshToken();
      return authResponse.pranaAccessToken;
    } catch (e) {
      print("토큰 갱신 콜백 오류 : $e");
      return null;
    }
  });
  return authService;
});

final authStateProvider = FutureProvider<bool>((ref) async {
  ref.watch(authRefreshProvider);
  final authService = ref.read(authServiceProvider);
  return authService.isLoggedIn();
});

final authRefreshProvider = StateProvider<int>((ref) => 0);

final signupServiceProvider = Provider<SignupService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SignupService(apiClient: apiClient);
});

final homeServiceProvider = Provider<HomeService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return HomeService(apiClient);
});

final homeDataProvider = FutureProvider<ReportResponse>((ref) async {
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
}
