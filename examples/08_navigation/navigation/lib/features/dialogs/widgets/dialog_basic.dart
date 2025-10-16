import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Basic Dialog - Used for simple decisions, confirmations, or alerts
// Characteristics:
// - Contains title, content, and action buttons
// - Takes minimal screen space (max 560dp width)
// - Dismisses on action or outside tap (if not critical)
class BasicDialog extends StatelessWidget {
  const BasicDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.delete_outline, size: 32),
      title: const Text('Delete Item?'),
      content: const Text(
        'Are you sure you want to delete this item? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop('Cancel'),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => context.pop('Delete'),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
