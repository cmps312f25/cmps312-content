import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/core/routing/app_router.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  // Navigation items configuration (only Profile and Settings)
  static const _navItems = [
    _NavItem(icon: Icons.person, label: 'Profile', route: AppRoutes.profile),
    _NavItem(
        icon: Icons.settings, label: 'Settings', route: AppRoutes.settings),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLocation = GoRouterState.of(context).uri.toString();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          ..._navItems
              .map((item) => _buildNavTile(context, item, currentLocation)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const DrawerHeader(
      decoration: BoxDecoration(color: Colors.blue),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Icon(Icons.navigation, size: 48, color: Colors.white),
          SizedBox(height: 8),
          Text(
            'Navigation Demo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile(
      BuildContext context, _NavItem item, String currentLocation) {
    final isSelected = currentLocation == item.route;

    return ListTile(
      leading: Icon(item.icon),
      title: Text(item.label),
      selected: isSelected,
      onTap: () {
        context.pop();
        if (!isSelected) {
          context.push(item.route);
        }
      },
    );
  }
}

// Data class for navigation items
class _NavItem {
  final IconData icon;
  final String label;
  final String route;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}
