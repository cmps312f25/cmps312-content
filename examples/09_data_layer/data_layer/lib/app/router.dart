import 'package:go_router/go_router.dart';
import 'package:data_layer/features/products/screens/products_screen.dart';
import 'package:data_layer/features/todos/screens/todo_screen.dart';
import 'package:data_layer/app/home_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
      path: '/todo',
      name: 'todo',
      builder: (context, state) => const TodoListScreen(),
    ),
    // Only products and todo routes remain
  ],
);
