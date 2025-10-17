import 'package:flutter/material.dart';
import 'package:navigation/core/routing/app_router.dart';

/// Application entry point
/// Initializes the Flutter app with GoRouter-based navigation
void main() => runApp(const App());

/// Root application widget
/// Configures MaterialApp with GoRouter and Material 3 theme
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      // Material 3 theme with dynamic color scheme
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true, // Enable Material 3 design
      ),
      routerConfig: appRouter,
    );
  }
}
