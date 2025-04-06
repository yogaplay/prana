import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/all/screens/see_all_screen.dart';
import 'package:frontend/core/providers/auth_providier.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/features/auth/screens/onboarding_screen.dart';
import 'package:frontend/features/auth/screens/signup_screen.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:frontend/features/learning/screens/learning/temp_result_page.dart';
import 'package:frontend/features/learning/screens/sequence_result_screen.dart';
import 'package:frontend/features/report/screens/report_screen.dart';
import 'package:frontend/features/learning/screens/learning_screen.dart';
import 'package:frontend/main_shell.dart';
import 'package:frontend/features/activity/screens/activity_screen.dart';
import 'package:frontend/features/profile/screens/info_page.dart';
import 'package:frontend/features/search/screens/search_input_screen.dart';
import 'package:frontend/features/search/screens/search_main_screen.dart';
import 'package:frontend/features/search/screens/search_result_screen.dart';
import 'package:frontend/features/learning/screens/sequence_detail_screen.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateNotifierProvider);

  final notifier = GoRouterNotifier(ref);

  ref.onDispose(() {
    notifier.dispose();
  });

  return GoRouter(
    initialLocation: "/",
    refreshListenable: notifier,
    redirect: (context, state) {
      final currentAuthState = authState;

      if (currentAuthState.status == AuthStatus.unknown) {
        return null; // 로딩 화면을 추가하거나, null 반환하여 현재 페이지 유지
      }

      // 이동하려는 경로 확인
      final isGoingToOnboarding = state.fullPath == '/onboarding';
      final isGoingToSignup = state.fullPath == '/signup';

      // 인증 상태에 따른 리다이렉트
      if (currentAuthState.status == AuthStatus.authenticated) {
        // 로그인된 상태에서 온보딩 페이지에 있으면
        if (isGoingToOnboarding) {
          if (currentAuthState.isFirstLogin) {
            return '/signup'; // 첫 로그인이면 회원가입 페이지로
          } else {
            return '/home'; // 아니면 홈 페이지로
          }
        }

        // 로그인된 상태에서 첫 로그인이 아닌데 회원가입 페이지로 가려고 하면
        if (isGoingToSignup && !authState.isFirstLogin) {
          return '/home'; // 홈 페이지로 리다이렉트
        }
      } else if (currentAuthState.status == AuthStatus.unauthenticated) {
        // 인증되지 않은 상태에서 온보딩 페이지가 아닌 페이지로 가려고 하면
        if (!isGoingToOnboarding) {
          return '/onboarding'; // 온보딩 페이지로 리다이렉트
        }
      }

      // 리다이렉트 필요 없음
      return null;
    },
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: "/",
            redirect: (_, __) => "/home", // 루트 경로에 접근하면 홈으로 리다이렉트
          ),
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
        path: "/see-all",
        name: "see_all",
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final tagName = extra['tagName'] as String;
          final tagType = extra['tagType'] as String;
          return SeeAllScreen(tagName: tagName, tagType: tagType);
        },
      ),
      GoRoute(
        path: "/weekly-report",
        name: "weekly_report",
        builder: (context, state) {
          final date = state.uri.queryParameters['date'] ?? '2025-03-30';
          return ReportScreen(date: date);
        },
      ),
      GoRoute(
        path: '/sequence/:id',
        name: 'sequenceDetail',
        builder: (context, state) {
          final sequenceId = int.parse(state.pathParameters['id']!);
          return SequenceDetailScreen(sequenceId: sequenceId);
        },
      ),
      GoRoute(
        path: '/sequence/:sequenceId/result/:userSequenceId',
        name: 'sequenceResult',
        builder: (context, state) {
          final sequenceId = int.parse(state.pathParameters['sequenceId']!);
          final userSequenceId = int.parse(
            state.pathParameters['userSequenceId']!,
          );
          return SequenceResultScreen(
            userSequenceId: userSequenceId,
            sequenceId: sequenceId,
          );
        },
      ),
      GoRoute(
        path: '/sequence/:id/learning',
        pageBuilder: (context, state) {
          final sequenceId = int.parse(state.pathParameters['id'] ?? '1');
          return MaterialPage(child: LearningScreen(sequenceId: sequenceId));
        },
      ),
      GoRoute(
        path: '/temp-result',
        name: 'tempResult',
        builder: (_, __) => const TempResultScreen(),
      ),
    ],
  );
});

class GoRouterNotifier extends ChangeNotifier {
  final Ref _ref;
  ProviderSubscription<AuthState>? _subscription;

  GoRouterNotifier(this._ref) {
    _subscription = _ref.listen<AuthState>(
      authStateNotifierProvider,
      (previous, next) {
        if (previous?.status != next.status ||
            previous?.isFirstLogin != next.isFirstLogin) {
          print('인증 상태 변경: ${previous?.status} -> ${next.status}');
          notifyListeners();
        }
      },
      onError: (error, stackTrace) {
        print('인증 상태 감시 중 오류: $error');
      },
    );
  }

  @override
  void dispose() {
    _subscription?.close();
    super.dispose();
  }
}
