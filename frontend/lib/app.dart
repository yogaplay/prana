import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/core/providers/providers.dart';
import 'package:frontend/routes.dart';
import 'package:frontend/features/search/screens/search_result_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'package:frontend/screens/main_screen.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initializeApp(ref);
    });
    return MaterialApp.router(
      title: 'Prana',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColors.background,
      ),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
