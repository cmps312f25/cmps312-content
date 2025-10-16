import 'package:flutter/material.dart';
import 'package:navigation/core/models/nav_item.dart';

/// Bottom navigation bar widget for primary app navigation
/// Displays Home, Fruits, and Dialogs tabs with icons and labels
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTapNavItem;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTapNavItem,
  });

  static const _navItems = [
    NavItem(icon: Icons.home, label: 'Home'),
    NavItem(icon: Icons.local_grocery_store, label: 'Fruits'),
    NavItem(icon: Icons.chat_bubble_outline, label: 'Dialogs & Sheets'),
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
