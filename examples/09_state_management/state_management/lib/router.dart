import 'package:go_router/go_router.dart';
import 'package:state_management/screens/app_config_screen.dart';
import 'package:state_management/screens/counter_screen.dart';
import 'package:state_management/screens/fruit_detail.dart';
import 'package:state_management/screens/fruits_list.dart';
import 'package:state_management/screens/home_screen.dart';
import 'package:state_management/screens/news_screen.dart';
import 'package:state_management/screens/products_list.dart';
import 'package:state_management/screens/todo_list.dart';
import 'package:state_management/screens/weather_screen.dart';

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
