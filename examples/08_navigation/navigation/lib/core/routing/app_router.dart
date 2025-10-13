import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/core/widgets/nav_bottom_bar.dart';
import 'package:navigation/features/dialogs/screens/dialogs_examples.dart';
import 'package:navigation/features/fruits/models/fruit.dart';
import 'package:navigation/features/fruits/screens/fruit_detail.dart';
import 'package:navigation/features/fruits/screens/fruits_list.dart';
import 'package:navigation/features/home/screens/home_screen.dart';
import 'package:navigation/features/profile/screens/profile_screen.dart';
import 'package:navigation/features/settings/screens/settings_screen.dart';

// Route names as constants to avoid hardcoded strings
class AppRoutes {
  static const home = '/';
  static const profile = '/profile';
  static const fruits = '/fruits';
  static const dialogs = '/dialogs';
  static const settings = '/settings';
  static const fruitDetails = '/fruitDetails';

  // Bottom navigation routes (Home, Fruits, and Dialogs)
  static const bottomNavRoutes = [home, fruits, dialogs];
}

// GoRouter configuration
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    // ShellRoute provides persistent bottom navigation bar for Home, Fruits, and Dialogs
    ShellRoute(
      builder: (context, state, child) {
        final currentLocation = state.uri.toString();
        final selectedIndex =
            AppRoutes.bottomNavRoutes.indexOf(currentLocation);

        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavBar(
            selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
            onTapNavItem: (index) =>
                context.go(AppRoutes.bottomNavRoutes[index]),
          ),
        );
      },
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: AppRoutes.fruits,
          builder: (context, state) => const FruitsScreen(),
        ),
        GoRoute(
          path: AppRoutes.dialogs,
          builder: (context, state) => const DialogsScreen(),
        ),
      ],
    ),
    // Profile and Settings are outside ShellRoute (no bottom nav)
    // Accessible only from drawer
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),
    // Detail screen without bottom nav
    GoRoute(
      path: AppRoutes.fruitDetails,
      builder: (context, state) {
        final fruit = state.extra as Fruit;
        return FruitDetailScreen(fruit: fruit);
      },
    ),
  ],
);
