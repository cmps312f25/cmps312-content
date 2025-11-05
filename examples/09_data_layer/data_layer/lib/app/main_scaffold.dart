import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Navigation configuration for app routes
/// Centralizes route metadata for consistent navigation UI
class AppRoute {
  final String path;
  final String name;
  final IconData icon;
  final String label;
  final Color color;

  const AppRoute({
    required this.path,
    required this.name,
    required this.icon,
    required this.label,
    required this.color,
  });
}

/// App route definitions - single source of truth for navigation
class AppRoutes {
  static const todo = AppRoute(
    path: '/todo',
    name: 'todo',
    icon: Icons.task_alt,
    label: 'Todos',
    color: Color(0xFF5E35B1), // Deep Purple 600
  );

  static const pets = AppRoute(
    path: '/pets',
    name: 'pets',
    icon: Icons.pets,
    label: 'Pets',
    color: Color(0xFFE64A19), // Deep Orange 700
  );

  static const products = AppRoute(
    path: '/products',
    name: 'products',
    icon: Icons.shopping_cart,
    label: 'Products',
    color: Color(0xFF00897B), // Teal 600
  );

  /// List of all routes for bottom navigation
  static const List<AppRoute> all = [todo, pets, products];
}

/// Main scaffold with bottom navigation bar
/// Wraps all screens to provide consistent navigation
class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).matchedLocation;

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomAppBar(
        height: 60,
        padding: EdgeInsets.zero,
        child: Row(
          children: AppRoutes.all.map((route) {
            final isActive = currentPath == route.path;
            final color = isActive ? route.color : Colors.grey;

            return Expanded(
              child: InkWell(
                onTap: () => context.go(route.path),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(route.icon, color: color, size: 24),
                    const SizedBox(height: 4),
                    Text(
                      route.label,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: isActive
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
