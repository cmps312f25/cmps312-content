import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:data_layer/features/pets/providers/pets_provider.dart';

class AddPetDialog extends ConsumerWidget {
  final int ownerId;

  const AddPetDialog({super.key, required this.ownerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    return AlertDialog(
      title: const Text('Add Pet'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Pet Name',
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
                  .read(petsProvider.notifier)
                  .addPet(controller.text.trim(), ownerId);
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
