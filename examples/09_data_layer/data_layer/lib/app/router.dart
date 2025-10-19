import 'package:go_router/go_router.dart';
import 'package:data_layer/features/products/screens/products_screen.dart';
import 'package:data_layer/features/todos/screens/todo_screen.dart';
import 'package:data_layer/app/main_scaffold.dart';

/// App router configuration using GoRouter
/// Todo screen is the initial route, all routes wrapped in MainScaffold
final GoRouter router = GoRouter(
  initialLocation: '/todo', // Todo screen is home
  routes: [
    // Wrap each route in MainScaffold for consistent bottom navigation
    GoRoute(
      path: '/todo',
      name: 'todo',
      builder: (context, state) => const MainScaffold(child: TodoListScreen()),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) => const MainScaffold(child: ProductsScreen()),
    ),
  ],
);
