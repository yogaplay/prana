import 'package:flutter/material.dart';
import 'package:frontend/widgets/navbar.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  final List<String> _tabs = ["/home", "/search", "/activity", "/info"];

  void _onTap(int index) {
    if (_currentIndex == index) return;
    context.go(_tabs[index]);
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: Navbar(currentIndex: _currentIndex, onTap: _onTap),
      ),
    );
  }
}
