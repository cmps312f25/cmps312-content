import 'package:flutter/material.dart';
import 'package:navigation/features/fruits/models/fruit.dart';

/// Fruit detail screen - Displays detailed information about a fruit
/// Receives fruit object via GoRouter's extra parameter
class FruitDetailScreen extends StatelessWidget {
  final Fruit fruit;

  const FruitDetailScreen({
    super.key,
    required this.fruit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fruit.name),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image section
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[100],
              child: Image.asset(
                fruit.imageUrl,
                fit: BoxFit.contain,
              ),
            ),

            // Content section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    fruit.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    fruit.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Divider
                  const Divider(),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    fruit.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
