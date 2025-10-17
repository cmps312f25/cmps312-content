import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/core/models/nav_item.dart';
import 'package:navigation/core/routing/app_router.dart';

/// Navigation drawer for secondary navigation (Profile, Settings)
class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  static const _navItems = [
    NavItem(icon: Icons.person, label: 'Profile', route: AppRoutes.profile),
    NavItem(icon: Icons.settings, label: 'Settings', route: AppRoutes.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(context),
          ..._navItems.map(
            (item) => _buildNavTile(context, item, currentLocation),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return DrawerHeader(
      margin: const EdgeInsets.only(bottom: 0),
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'More Options',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
            tooltip: 'Close drawer',
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile(
    BuildContext context,
    NavItem item,
    String currentLocation,
  ) {
    final isSelected = currentLocation == item.route;

    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.label),
      selected: isSelected,
      onTap: () {
        context.pop(); // Close drawer using go_router
        if (!isSelected) {
          context.go(item.route!); // Navigate using go_router
        }
      },
    );
  }
}
