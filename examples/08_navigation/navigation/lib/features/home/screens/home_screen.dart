import 'package:flutter/material.dart';
import 'package:navigation/core/widgets/nav_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Each screen provides its own Scaffold, AppBar, and Drawer
    // ShellRoute only provides the persistent bottom navigation bar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      drawer: const NavDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Navigation Demo!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
