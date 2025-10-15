import 'package:flutter/material.dart';
import 'package:navigation/features/fruits/models/fruit.dart';

/// Reusable list item widget for displaying fruit information
/// Follows Single Responsibility Principle - only handles fruit display
class FruitListTile extends StatelessWidget {
  final Fruit fruit;
  final VoidCallback onTap;

  const FruitListTile({
    super.key,
    required this.fruit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Rounded image with 10px border radius for Material 3 design
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          fruit.imageUrl,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      ),
      title: Text(
        fruit.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(fruit.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
