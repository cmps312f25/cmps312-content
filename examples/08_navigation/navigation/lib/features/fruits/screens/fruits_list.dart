import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/core/routing/app_router.dart';
import 'package:navigation/core/widgets/nav_drawer.dart';
import 'package:navigation/features/fruits/repositories/fruit_repository.dart';
import 'package:navigation/features/fruits/widgets/fruit_list_tile.dart';

/// Fruits list screen - Displays all available fruits
/// Demonstrates ListView with navigation to detail screen
class FruitsScreen extends StatelessWidget {
  const FruitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch fruit data from repository
    // In production, consider using FutureBuilder for async data
    final fruits = FruitRepository.getFruits();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits List'),
        backgroundColor: Colors.orange,
      ),
      drawer: const NavDrawer(),
      body: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final fruit = fruits[index];
          return FruitListTile(
            fruit: fruit,
            // Navigate to detail screen, passing fruit object via extra
            onTap: () => context.push(
              AppRoutes.fruitDetails,
              extra: fruit,
            ),
          );
        },
      ),
    );
  }
}
