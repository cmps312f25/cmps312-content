import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTapNavItem;

  const BottomNavBar({
    required this.selectedIndex,
    required this.onTapNavItem,
    super.key,
  });

  // Navigation items configuration (Home, Fruits, and Dialogs)
  static const _navItems = [
    (icon: Icons.home, label: 'Home'),
    (icon: Icons.local_grocery_store, label: 'Fruits'),
    (icon: Icons.chat_bubble_outline, label: 'Dialogs'),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: onTapNavItem,
      items: _navItems
          .map((item) => BottomNavigationBarItem(
                icon: Icon(item.icon),
                label: item.label,
              ))
          .toList(),
    );
  }
}
