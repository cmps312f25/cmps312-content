import 'package:flutter/material.dart';
import 'package:navigation/app/widgets/nav_drawer.dart';
import 'package:navigation/app/widgets/nav_rail.dart';

/// Tablet/Desktop layout with navigation rail and drawer
class TabletDesktopScaffold extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget child;

  const TabletDesktopScaffold({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      body: Row(
        children: [
          NavRail(
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            extended: false,
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
