import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_app/features/pets/providers/pets_provider.dart';

class PetsSummaryDialog extends ConsumerWidget {
  const PetsSummaryDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsWithOwnersAsync = ref.watch(petsWithOwnersProvider);

    return AlertDialog(
      title: const Text('Pets Summary'),
      content: SizedBox(
        width: double.maxFinite,
        child: petsWithOwnersAsync.when(
          data: (petsWithOwners) {
            if (petsWithOwners.isEmpty) {
              return const Center(child: Text('No pets found'));
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: petsWithOwners.length,
              itemBuilder: (context, index) {
                final petOwner = petsWithOwners[index];
                return ListTile(
                  leading: const Icon(Icons.pets),
                  title: Text(petOwner.petName),
                  subtitle: Text('Owner: ${petOwner.ownerFullName}'),
                );
              },
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text('Close')),
      ],
    );
  }
}
