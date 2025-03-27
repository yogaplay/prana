import 'package:flutter/material.dart';
import 'package:frontend/features/home/screens/home_screen.dart';
import 'package:frontend/screens/activity_page.dart';
import 'package:frontend/screens/explore_page.dart';
import 'package:frontend/screens/info_page.dart';
import 'package:frontend/widgets/navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ExploerPage(),
    ActivityPage(),
    InfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
