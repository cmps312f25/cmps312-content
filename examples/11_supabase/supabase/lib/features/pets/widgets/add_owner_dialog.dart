import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_app/features/pets/providers/owners_provider.dart';

class AddOwnerDialog extends ConsumerWidget {
  const AddOwnerDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();

    return AlertDialog(
      title: const Text('Add Owner'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: firstNameController,
            decoration: const InputDecoration(
              labelText: 'First Name',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: lastNameController,
            decoration: const InputDecoration(
              labelText: 'Last Name',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Cancel')),
        FilledButton(
          onPressed: () async {
            if (firstNameController.text.trim().isNotEmpty &&
                lastNameController.text.trim().isNotEmpty) {
              await ref
                  .read(ownersProvider.notifier)
                  .addOwner(
                    firstNameController.text.trim(),
                    lastNameController.text.trim(),
                  );
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
