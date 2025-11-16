import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_app/features/pets/providers/owners_provider.dart';

class AddOwnerDialog extends ConsumerWidget {
  const AddOwnerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    return AlertDialog(
      title: const Text('Add Owner'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Owner Name',
          border: OutlineInputBorder(),
        ),
        autofocus: true,
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () async {
            if (controller.text.trim().isNotEmpty) {
              await ref
                  .read(ownersProvider.notifier)
                  .addOwner(controller.text.trim());
              // Close the dialog
              // .mounted is checked to ensure the context is still valid
              if (context.mounted) context.pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
