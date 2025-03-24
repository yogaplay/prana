import 'package:flutter/material.dart';
import 'package:frontend/constants/app_colors.dart';

class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const Navbar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    const items = [
      _NavItemData(icon: Icons.home, label: ' 홈'),
      _NavItemData(icon: Icons.search, label: ' 둘러보기'),
      _NavItemData(icon: Icons.calendar_month, label: '활동'),
      _NavItemData(icon: Icons.person_outline, label: '내 정보'),
    ];
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.translucent,
            child: _NavItem(
              icon: items[index].icon,
              label: items[index].label,
              isSelected: isSelected,
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : Colors.transparent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: AppColors.blackText),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: AppColors.blackText, fontSize: 14)),
      ],
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;

  const _NavItemData({required this.icon, required this.label});
}
