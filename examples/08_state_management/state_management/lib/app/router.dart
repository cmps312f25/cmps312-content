import 'package:go_router/go_router.dart';
import 'package:state_management/features/app_config/screens/app_config_screen.dart';
import 'package:state_management/features/counter/screens/counter_screen.dart';
import 'package:state_management/features/fruits/screens/fruit_detail_screen.dart';
import 'package:state_management/features/fruits/screens/fruits_screen.dart';
import 'package:state_management/features/news/screens/news_screen.dart';
import 'package:state_management/features/products/screens/products_screen.dart';
import 'package:state_management/features/todos/screens/todo_screen.dart';
import 'package:state_management/features/weather/screens/weather_screen.dart';
import 'package:state_management/app/home_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/counter',
      name: 'counter',
      builder: (context, state) => const CounterScreen(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) => const ProductsScreen(),
    ),
    GoRoute(
      path: '/fruits',
      name: 'fruits',
      builder: (context, state) => const FruitsScreen(),
      routes: [
        GoRoute(
          path: ':fruitName',
          name: 'fruit-detail',
          builder: (context, state) {
            final fruitName = state.pathParameters['fruitName']!;
            return FruitDetailScreen(fruitName: fruitName);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/todo',
      name: 'todo',
      builder: (context, state) => const TodoListScreen(),
    ),
    GoRoute(
      path: '/weather',
      name: 'weather',
      builder: (context, state) => const WeatherScreen(),
    ),
    GoRoute(
      path: '/stock',
      name: 'stock',
      builder: (context, state) => const NewsScreen(),
    ),
    GoRoute(
      path: '/app_config',
      name: 'app_config',
      builder: (context, state) => const AppConfigScreen(),
    ),
  ],
);
