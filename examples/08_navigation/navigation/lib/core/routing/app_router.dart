import 'package:go_router/go_router.dart';
import 'package:navigation/core/widgets/nav_scaffold_responsive.dart';
import 'package:navigation/features/dialogs/screens/dialogs_sheets.dart';
import 'package:navigation/features/dialogs/widgets/dialog_fullscreen.dart';
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
/// 
/// Architecture Decision:
/// - ShellRoute provides persistent navigation chrome (bottom bar/rail/drawer)
/// - Routes outside ShellRoute are standalone (no persistent navigation)
/// - This separation ensures navigation state is preserved within the shell
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    // ShellRoute wraps main app screens with responsive navigation
    // The navigation adapts automatically based on screen width:
    //   - Mobile: Bottom Navigation Bar
    //   - Tablet: Navigation Rail (collapsed) + Drawer
    //   - Desktop: Navigation Rail (extended) + Drawer
    ShellRoute(
      builder: (context, state, child) {
        // Determine which navigation item should be selected
        // based on current route location
        final currentLocation = state.uri.toString();
        final selectedIndex =
            AppRoutes.bottomNavRoutes.indexOf(currentLocation);

        // ResponsiveNavScaffold automatically selects the appropriate
        // navigation pattern based on available screen width
        return ResponsiveNavScaffold(
          selectedIndex: selectedIndex >= 0 ? selectedIndex : 0,
          onDestinationSelected: (index) =>
              context.go(AppRoutes.bottomNavRoutes[index]),
          child: child, // Current screen content
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
          builder: (context, state) => const DialogsSheetsScreen(),
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
