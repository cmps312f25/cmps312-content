import 'package:flutter/material.dart';
import 'package:navigation/app/widgets/nav_drawer.dart';

/// Home screen - Landing page of the application
/// Demonstrates basic screen structure with AppBar and Drawer
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Each screen provides its own Scaffold, AppBar, and Drawer
    // ShellRoute (in app_router.dart) only provides the bottom navigation bar
    // Drawer only shown on small screens (< 600dp)
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: isSmallScreen ? const NavDrawer() : null,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Navigation Demo!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Explore navigation patterns using the bottom navigation bar and drawer',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
