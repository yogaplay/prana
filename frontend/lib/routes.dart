import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/auth/screens/onboarding_screen.dart';
import 'package:frontend/features/auth/screens/signup_screen.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:frontend/features/report/screens/report_screen.dart';
import 'package:frontend/features/search/screens/see_all_screen.dart';
import 'package:frontend/main_shell.dart';
import 'package:frontend/features/activity/screens/activity_screen.dart';
import 'package:frontend/features/profile/screens/info_page.dart';
import 'package:frontend/features/search/screens/search_input_screen.dart';
import 'package:frontend/features/search/screens/search_main_screen.dart';
import 'package:frontend/features/search/screens/search_result_screen.dart';
import 'package:frontend/features/learning/screens/sequence_detail_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isFirstLoginAsync = ref.watch(isFirstLoginProvider);

  return GoRouter(
    initialLocation: "/home",
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
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: "/home",
            name: "home",
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: "/search",
            name: "search",
            builder: (_, __) => SearchMainScreen(),
          ),
          GoRoute(
            path: "/activity",
            name: "activity",
            builder: (_, __) => ActivityPage(),
          ),
          GoRoute(path: "/info", name: "info", builder: (_, __) => InfoPage()),
        ],
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
        path: '/home/detail/:title',
        builder: (context, state) {
          final title = state.pathParameters['title']!;
          return DetailPage(title: title);
        },
      ),
      GoRoute(
        path: "/search/input",
        name: "search_input",
        builder: (context, state) {
          final onSubmitted = state.extra as void Function(String);
          return SearchInputScreen(onSubmitted: onSubmitted);
        },
      ),
      GoRoute(
        path: "/search/result",
        name: "search_result",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SearchResultScreen(
            keyword: extra['keyword'] as String,
            selectedFilters: extra['selectedFilters'] as List<String>,
          );
        },
      ),
      GoRoute(
        path: "/search/see-all",
        name: "search_see_all",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SeeAllScreen(
            tagName: extra['tagName'] as String,
            tagType: extra['tagType'] as String,
          );
        },
      ),
      GoRoute(
        path: "/weekly-report",
        name: "weekly_report",
        builder: (_, __) => const ReportScreen(),
      ),
      GoRoute(
        path: '/sequence/:id',
        name: 'sequenceDetail',
        builder: (context, state) {
          final sequenceId = int.parse(state.pathParameters['id']!);
          return SequenceDetailScreen(sequenceId: sequenceId);
        },
      ),
    ],
  );
});
