import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:navigation/core/routing/app_router.dart';
import 'package:navigation/core/widgets/nav_drawer.dart';
import 'package:navigation/features/fruits/repositories/fruit_repository.dart';
import 'package:navigation/features/fruits/widgets/fruit_list_tile.dart';

class FruitsScreen extends StatelessWidget {
  const FruitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final fruits = FruitRepository.getFruits();

    // Each screen provides its own Scaffold with AppBar and Drawer
    // ShellRoute only provides the persistent bottom navigation bar
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits List'),
        backgroundColor: Colors.orange,
      ),
      drawer: const NavDrawer(),
      body: ListView.builder(
        itemCount: fruits.length,
        itemBuilder: (context, index) => FruitListTile(
          fruit: fruits[index],
          onTap: () =>
              context.push(AppRoutes.fruitDetails, extra: fruits[index]),
        ),
      ),
    );
  }
}
