import 'package:go_router/go_router.dart';
import 'package:data_layer/features/products/screens/products_screen.dart';
import 'package:data_layer/features/todos/screens/todo_screen.dart';
import 'package:data_layer/app/main_scaffold.dart';

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
          path: '/products',
          name: 'products',
          builder: (context, state) => const ProductsScreen(),
        ),
      ],
    ),
  ],
);
