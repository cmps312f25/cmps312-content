import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/core/widgets/nav_bottom_bar.dart';
import 'package:navigation/features/dialogs/screens/dialogs_examples.dart';
import 'package:navigation/features/dialogs/widgets/fullscreen_dialog.dart';
import 'package:navigation/features/fruits/models/fruit.dart';
import 'package:navigation/features/fruits/screens/fruit_detail.dart';
import 'package:navigation/features/fruits/screens/fruits_list.dart';
import 'package:navigation/features/home/screens/home_screen.dart';
import 'package:navigation/features/profile/screens/profile_screen.dart';
import 'package:navigation/features/settings/screens/settings_screen.dart';

/// Route path constants
/// Centralized route definitions prevent typos and improve maintainability
class AppRoutes {
  // Private constructor prevents instantiation
  AppRoutes._();

  // Bottom navigation routes
  static const home = '/';
  static const fruits = '/fruits';
  static const dialogs = '/dialogs';

  // Drawer navigation routes
  static const profile = '/profile';
  static const settings = '/settings';

  // Detail/Dialog routes
  static const fruitDetails = '/fruitDetails';
  static const fullscreenDialog = '/fullscreenDialog';

  /// Routes that display bottom navigation bar
  static const bottomNavRoutes = [home, fruits, dialogs];
}

/// Global GoRouter configuration
/// Defines app navigation structure using declarative routing
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    // ShellRoute provides persistent bottom navigation for main screens
    // Keeps bottom bar visible while navigating between Home, Fruits, Dialogs
    ShellRoute(
      builder: (context, state, child) {
        final currentLocation = state.uri.toString();
        final selectedIndex =
            AppRoutes.bottomNavRoutes.indexOf(currentLocation);

        return Scaffold(
          body: child, // Current screen content
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

    // Routes outside ShellRoute - no bottom navigation bar
    // Profile and Settings accessible only from drawer
    GoRoute(
      path: AppRoutes.profile,
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (context, state) => const SettingsScreen(),
    ),

    // Detail screen - receives Fruit object via extra parameter
    GoRoute(
      path: AppRoutes.fruitDetails,
      builder: (context, state) {
        final fruit = state.extra as Fruit;
        return FruitDetailScreen(fruit: fruit);
      },
    ),

    // Fullscreen dialog example
    GoRoute(
      path: AppRoutes.fullscreenDialog,
      builder: (context, state) => const FullScreenDialog(),
    ),
  ],
);
