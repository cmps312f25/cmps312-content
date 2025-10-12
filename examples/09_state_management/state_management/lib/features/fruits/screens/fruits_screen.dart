import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:state_management/features/fruits/providers/fruits_provider.dart';
import 'package:state_management/features/fruits/widgets/fruit_tile.dart';

class FruitsScreen extends ConsumerWidget {
  const FruitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fruitsAsync = ref.watch(fruitsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fruits List'),
        backgroundColor: Colors.orange,
      ),
      body: fruitsAsync.when(
        data: (fruits) => ListView.builder(
          itemCount: fruits.length,
          itemBuilder: (context, index) {
            final fruit = fruits[index];
            return FruitTile(
              fruit: fruit,
              onTap: () => context.push('/fruits/${fruit.name}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
