import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app/features/pets/models/owner.dart';
import 'package:supabase_app/features/pets/providers/owners_provider.dart';
import 'package:supabase_app/features/pets/providers/pets_provider.dart';
import 'package:supabase_app/features/pets/widgets/confirm_delete_dialog.dart';

class OwnersList extends ConsumerWidget {
  const OwnersList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownersAsync = ref.watch(ownersProvider);
    final selectedOwnerId = ref.watch(selectedOwnerIdProvider);

    return Container(
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(
            child: ownersAsync.when(
              data: (owners) =>
                  _buildOwnersList(context, ref, owners, selectedOwnerId),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: const Text(
        'Owners',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOwnersList(
    BuildContext context,
    WidgetRef ref,
    List<Owner> owners,
    int? selectedOwnerId,
  ) {
    if (owners.isEmpty) {
      return const Center(child: Text('No owners yet'));
    }

    return ListView.builder(
      itemCount: owners.length,
      itemBuilder: (context, index) {
        final owner = owners[index];
        final isSelected = selectedOwnerId == owner.id;
        return ListTile(
          title: Text(owner.name),
          selected: isSelected,
          selectedTileColor: Colors.teal.shade50,
          trailing: IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: Colors.red,
            onPressed: () =>
                _handleDeleteOwner(context, ref, owner, selectedOwnerId),
          ),
          onTap: () =>
              ref.read(selectedOwnerIdProvider.notifier).selectOwner(owner.id),
        );
      },
    );
  }

  Future<void> _handleDeleteOwner(
    BuildContext context,
    WidgetRef ref,
    Owner owner,
    int? selectedOwnerId,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        title: 'Delete Owner',
        message:
            'This will also delete all pets owned by ${owner.name}. Continue?',
      ),
    );

    if (confirm == true) {
      await ref.read(ownersProvider.notifier).deleteOwner(owner.id!);

      // Clear selection if deleted owner was selected
      if (selectedOwnerId == owner.id) {
        ref.read(selectedOwnerIdProvider.notifier).selectOwner(null);
      }
    }
  }
}
