import 'package:flutter/material.dart';
import 'package:navigation/app/widgets/nav_bottom_bar.dart';

/// Mobile layout with bottom navigation bar
class MobileScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  const MobileScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onTapNavItem: onDestinationSelected,
      ),
    );
  }
}
