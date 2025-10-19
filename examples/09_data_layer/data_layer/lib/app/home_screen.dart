import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Route configuration model
class NavigationRoute {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;

  const NavigationRoute({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
    required this.color,
  });
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Define all available routes with their metadata
  static const List<NavigationRoute> _allRoutes = [
    NavigationRoute(
      icon: Icons.shopping_cart,
      title: 'Products',
      subtitle: 'FutureProvider Example',
      route: '/products',
      color: Color(0xFF00897B), // Teal 600
    ),
    NavigationRoute(
      icon: Icons.task_alt,
      title: 'Todo List',
      subtitle: 'AsyncNotifierProvider Example',
      route: '/todo',
      color: Color(0xFF5E35B1), // Deep Purple 600
    ),
    // Only products and todo remain
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Layer Demo'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Riverpod Provider Examples',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              // Dynamically build navigation buttons from routes array
              ..._allRoutes.map(
                (route) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildNavigationButton(context, route),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context, NavigationRoute route) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: route.color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {
          context.push(route.route);
        },
        child: Row(
          children: [
            Icon(route.icon, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    route.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    route.subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 20),
          ],
        ),
      ),
    );
  }
}
