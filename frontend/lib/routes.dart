import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/auth/screens/onboarding_screen.dart';
import 'package:frontend/features/auth/screens/signup_screen.dart';
import 'package:frontend/screens/main_screen.dart';
import 'package:frontend/features/search/screens/search_main_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isFirstLoginAsync = ref.watch(isFirstLoginProvider);

  return GoRouter(
    initialLocation: "/onboarding",
    redirect: (context, state) {
      // authState가 로딩 중이면 null 반환(현재 경로 유지)
      if (authState.isLoading) return null;

      final isLoggedIn = authState.valueOrNull ?? false;

      // 로그인되어 있지 않으면 온보딩 페이지로
      if (!isLoggedIn && state.fullPath != '/onboarding') {
        return '/onboarding';
      }

      // 로그인된 상태에서 온보딩 페이지에 있으면
      if (isLoggedIn && state.fullPath == '/onboarding') {
        if (!isFirstLoginAsync.isLoading && !isFirstLoginAsync.hasError) {
          final bool isFirstLogin = isFirstLoginAsync.value ?? false;
          if (isFirstLogin) {
            return '/signup';
          } else {
            return '/home';
          }
        }
        return null;
      }

      // 로그인된 상태에서 회원가입 페이지는 그대로 유지
      if (isLoggedIn && state.fullPath == '/signup') {
        return null;
      }

      // 나머지 경우에는 요청된 페이지로 이동
      return null;
    },
    routes: [
      GoRoute(
        path: "/home",
        name: "home",
        builder: (_, __) => const MainScreen(),
      ),
      GoRoute(
        path: "/onboarding",
        name: "onboarding",
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: "/signup",
        name: "signup",
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: "/search",
        name: "search",
        builder: (_, __) => SearchMainScreen(),
      ),
    ],
  );
});
