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
      icon: Icons.link,
      title: 'App Config',
      subtitle: 'Provider Example',
      route: '/app_config',
      color: Colors.blue,
    ),
    NavigationRoute(
      icon: Icons.add_circle,
      title: 'Counter',
      subtitle: 'NotifierProvider Example',
      route: '/counter',
      color: Colors.green,
    ),
    NavigationRoute(
      icon: Icons.shopping_cart,
      title: 'Products',
      subtitle: 'AsyncNotifierProvider Example',
      route: '/products',
      color: Colors.orange,
    ),
    NavigationRoute(
      icon: Icons.apple,
      title: 'Fruits',
      subtitle: 'Provider with Navigation',
      route: '/fruits',
      color: Colors.red,
    ),
    NavigationRoute(
      icon: Icons.task_alt,
      title: 'Todo List',
      subtitle: 'Filtered State Example',
      route: '/todo',
      color: Colors.purple,
    ),
    NavigationRoute(
      icon: Icons.cloud,
      title: 'Weather',
      subtitle: 'FutureProvider Example',
      route: '/weather',
      color: Colors.lightBlue,
    ),
    NavigationRoute(
      icon: Icons.article,
      title: 'Top News',
      subtitle: 'StreamProvider Example',
      route: '/stock',
      color: Colors.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State Management Demo'),
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
