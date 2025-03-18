import 'package:flutter/material.dart';
import 'features/onboarding/pages/onboarding_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prana',
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: OnboardingPage(),
    );
  }
}
