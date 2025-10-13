import 'package:flutter/material.dart';

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
      // Icon helps users quickly identify dialog purpose
      icon: const Icon(Icons.delete_outline, size: 32),
      title: const Text('Delete Item?'),
      content: const Text(
        'Are you sure you want to delete this item? This action cannot be undone.',
      ),
      actions: [
        // Cancel action - typically appears first
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        // Primary action - use FilledButton for emphasis
        FilledButton(
          onPressed: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item deleted')),
            );
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
