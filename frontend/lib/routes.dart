import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/auth/screens/onboarding_screen.dart';
import 'package:frontend/features/auth/screens/signup_screen.dart';
import 'package:frontend/screens/main_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: "/onboarding",
    redirect: (context, state) {
      // authState가 로딩 중이면 null 반환(현재 경로 유지)
      if (authState.isLoading) return null;

      final isLoggedIn = authState.valueOrNull ?? false;
      final isOnLoginPage =
          state.fullPath == '/onboarding' || state.fullPath == '/signup';

      // 로그인되어 있는데 로그인/회원가입 페이지에 있으면 홈으로
      if (isLoggedIn && isOnLoginPage) return '/home';

      // 로그인되어 있지 않은데 홈 페이지나 인증이 필요한 페이지에 있으면 온보딩으로
      if (!isLoggedIn && !isOnLoginPage) return '/onboarding';

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
    ],
  );
});
