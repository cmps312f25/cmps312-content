import 'package:go_router/go_router.dart';
import 'package:supabase_app/features/todos/screens/todo_screen.dart';
import 'package:supabase_app/features/pets/screens/pets_screen.dart';
import 'package:supabase_app/app/main_scaffold.dart';

/// App router configuration using GoRouter with ShellRoute
/// ShellRoute provides persistent bottom navigation across all screens
final GoRouter router = GoRouter(
  initialLocation: '/todo',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(
          path: '/todo',
          name: 'todo',
          builder: (context, state) => const TodoListScreen(),
        ),
        GoRoute(
          path: '/pets',
          name: 'pets',
          builder: (context, state) => const PetsScreen(),
        ),
      ],
    ),
  ],
);
