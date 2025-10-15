import 'package:flutter/material.dart';

/// Bottom navigation bar widget for primary app navigation
/// Displays Home, Fruits, and Dialogs tabs with icons and labels
/// Uses composition pattern - receives state and callbacks from parent
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTapNavItem;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTapNavItem,
  });

  // Navigation items configuration - using records for type safety
  // Records (tuples) are immutable and perfect for configuration data
  static const _navItems = [
    (icon: Icons.home, label: 'Home'),
    (icon: Icons.local_grocery_store, label: 'Fruits'),
    (icon: Icons.chat_bubble_outline, label: 'Dialogs & Sheets'),
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
