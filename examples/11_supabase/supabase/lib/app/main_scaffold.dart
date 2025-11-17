import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_app/features/auth/providers/auth_provider.dart';

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

  /// List of all routes for bottom navigation
  static const List<AppRoute> all = [todo, pets];
}

/// Main scaffold with bottom navigation bar
/// Wraps all screens to provide consistent navigation
class MainScaffold extends ConsumerWidget {
  final Widget child;

  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentPath = GoRouterState.of(context).matchedLocation;
    final authRepository = ref.read(authRepositoryProvider);
    final userFullName = authRepository.userFullName ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppRoutes.all
              .firstWhere(
                (r) => r.path == currentPath,
                orElse: () => AppRoutes.todo,
              )
              .label,
        ),
        actions: [
          // User info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Text(
                userFullName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // Sign out button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () async {
              // Confirm sign out
              final shouldSignOut = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );

              if (shouldSignOut == true && context.mounted) {
                try {
                  await authRepository.signOut();
                  if (context.mounted) {
                    context.go('/signin');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error signing out: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
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
