import 'package:frontend/features/auth/screens/onboarding_screen.dart';
import 'package:frontend/features/auth/screens/signup_screen.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  static GoRouter router = GoRouter(
    initialLocation: "/onboarding",
    routes: [
      GoRoute(
        path: "/home",
        name: "home",
        builder: (_, __) => const HomeScreen(),
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
}
