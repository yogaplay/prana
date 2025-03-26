import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/api/api_client.dart';
import 'package:frontend/features/auth/services/auth_service.dart';
import 'package:frontend/features/auth/services/signup_service.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://j12a103.p.ssafy.io:8444/api');
});

final authServiceProvider = Provider<AuthService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthService(apiClient: apiClient);
});

final authStateProvider = FutureProvider<bool>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.isLoggedIn();
});

final signupServiceProvider = Provider<SignupService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SignupService(apiClient: apiClient);
});

Future<void> initializeApp(WidgetRef ref) async {
  final authService = ref.read(authServiceProvider);
  await authService.initializeTokens();
}
