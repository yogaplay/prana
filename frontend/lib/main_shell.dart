import 'package:flutter/material.dart';
import 'package:frontend/widgets/navbar.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  final String currentPath;
  const MainShell({super.key, required this.child, required this.currentPath});

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ["/home", "/search", "/activity", "/info"];

    final currentIndex = tabs.indexWhere((tab) => currentPath.startsWith(tab));

    return SafeArea(
      child: Scaffold(
        body: child,
        bottomNavigationBar: Navbar(
          currentIndex: currentIndex == -1 ? 0 : currentIndex,
          onTap: (index) {
            final selectedPath = tabs[index];
            if (selectedPath != currentPath) {
              context.go(selectedPath);
            }
          },
        ),
      ),
    );
  }
}
