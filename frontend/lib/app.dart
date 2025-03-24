import 'package:flutter/material.dart';
import 'features/activity/pages/activity_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prana',
      theme: ThemeData(fontFamily: 'Pretendard'),
      home: ActivityPage(),
    );
  }
}
