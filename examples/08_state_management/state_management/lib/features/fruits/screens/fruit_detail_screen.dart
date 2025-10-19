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
              // Image takes 80% of available space
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    fruit.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.contain, // Show full image without cropping
                  ),
                ),
              ),
              // Description takes 20% of available space, no scrolling
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    fruit.description,
                    style: const TextStyle(fontSize: 16),
                    maxLines: null, // Allow text to wrap
                    overflow: TextOverflow.visible, // Show all text
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Text('Error: $err', style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }
}
