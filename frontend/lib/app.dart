import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';
import 'package:frontend/screens/main_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prana',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: AppColors.background,
      ),
      home: MainScreen(),
    );
  }
}
