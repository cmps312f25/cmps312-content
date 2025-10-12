import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:state_management/features/fruits/providers/fruits_provider.dart';

class FruitDetailScreen extends ConsumerWidget {
  final String fruitName;

  const FruitDetailScreen({super.key, required this.fruitName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fruitsAsync = ref.watch(fruitsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(fruitName), backgroundColor: Colors.orange),
      body: fruitsAsync.when(
        data: (fruits) {
          final fruit = fruits.firstWhere((f) => f.name == fruitName);
          return Column(
            children: [
              Image.asset(
                fruit.imageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  fruit.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
