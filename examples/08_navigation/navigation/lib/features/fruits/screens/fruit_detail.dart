import 'package:flutter/material.dart';
import 'package:navigation/features/fruits/models/fruit.dart';

class FruitDetailScreen extends StatelessWidget {
  final Fruit fruit;

  const FruitDetailScreen({super.key, required this.fruit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fruit.name),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.asset(
              fruit.imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(fruit.description),
          ),
        ],
      ),
    );
  }
}
