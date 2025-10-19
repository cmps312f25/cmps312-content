import 'package:flutter/material.dart';
import 'package:navigation/app/models/nav_item.dart';

/// Navigation Rail for tablet and desktop (≥600dp)
/// Displays vertical navigation with hamburger menu for drawer access
class NavRail extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final bool extended;

  const NavRail({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.extended = false,
  });

  static const _destinations = [
    NavItem(icon: Icons.home, label: 'Home'),
    NavItem(icon: Icons.local_grocery_store, label: 'Fruits'),
    NavItem(icon: Icons.chat_bubble_outline, label: 'Dialogs'),
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: 'Menu',
        ),
      ),
      extended: extended,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      labelType:
          extended ? NavigationRailLabelType.none : NavigationRailLabelType.all,
      destinations: _destinations
          .map((dest) => NavigationRailDestination(
                icon: Icon(dest.icon),
                selectedIcon: Icon(dest.icon, fill: 1.0),
                label: Text(dest.label),
              ))
          .toList(),
    );
  }
}
