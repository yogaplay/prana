import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/routes.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Prana',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColors.background,
      ),
      routerConfig: Routes.router,
    );
  }
}
