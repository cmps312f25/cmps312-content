import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_app/features/todos/screens/todo_screen.dart';
import 'package:supabase_app/features/pets/screens/pets_screen.dart';
import 'package:supabase_app/features/auth/screens/signin_screen.dart';
import 'package:supabase_app/features/auth/screens/signup_screen.dart';
import 'package:supabase_app/features/auth/providers/auth_provider.dart';
import 'package:supabase_app/app/main_scaffold.dart';

/// App router configuration using GoRouter with authentication
final routerProvider = Provider<GoRouter>((ref) {
  final isAuthenticated = ref.watch(isAuthenticatedProvider);

  return GoRouter(
    initialLocation: '/todo',
    redirect: (context, state) {
      final isAuthenticatedValue = isAuthenticated.value ?? false;
      final isAuthRoute =
          state.matchedLocation == '/signin' ||
          state.matchedLocation == '/signup';

      // If not authenticated and not on auth route, redirect to signin
      if (!isAuthenticatedValue && !isAuthRoute) {
        return '/signin';
      }

      // If authenticated and on auth route, redirect to home
      if (isAuthenticatedValue && isAuthRoute) {
        return '/todo';
      }

      return null;
    },
    routes: [
      // Auth Routes (no shell)
      GoRoute(
        path: '/signin',
        name: 'signin',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignUpScreen(),
      ),

      // App Routes (with shell for navigation)
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
});
