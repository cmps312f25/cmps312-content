import 'package:flutter/material.dart';

/// Navigation item model for all navigation components
/// Encapsulates icon, label, and optional route information
class NavItem {
  final IconData icon;
  final String label;
  final String? route; // Optional for primary nav items (Home, Fruits, Dialogs)

  const NavItem({
    required this.icon,
    required this.label,
    this.route,
  });
}
