import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/pets/models/pet.dart';
import 'package:data_layer/features/pets/providers/pets_provider.dart';
import 'package:data_layer/features/pets/widgets/add_pet_dialog.dart';
import 'package:data_layer/features/pets/widgets/confirm_delete_dialog.dart';

class PetsList extends ConsumerWidget {
  final int? selectedOwnerId;

  const PetsList({super.key, required this.selectedOwnerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final petsAsync = ref.watch(petsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context, ref),
        Expanded(
          child: selectedOwnerId == null
              ? _buildEmptyState()
              : petsAsync.when(
                  data: (pets) => _buildPetsList(context, ref, pets),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Error: $error')),
                ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            selectedOwnerId == null ? 'Select an owner to view pets' : 'Pets',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (selectedOwnerId != null)
            TextButton.icon(
              icon: const Icon(Icons.pets),
              label: const Text('Add Pet'),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => AddPetDialog(ownerId: selectedOwnerId!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.pets, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Select an owner from the left',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPetsList(BuildContext context, WidgetRef ref, List<Pet> pets) {
    if (pets.isEmpty) {
      return const Center(child: Text('No pets for this owner'));
    }

    return ListView.builder(
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return ListTile(
          leading: const Icon(Icons.pets),
          title: Text(pet.name),
          trailing: IconButton(
            icon: const Icon(Icons.delete, size: 20),
            color: Colors.red,
            onPressed: () => _handleDeletePet(context, ref, pet),
          ),
        );
      },
    );
  }

  Future<void> _handleDeletePet(
    BuildContext context,
    WidgetRef ref,
    Pet pet,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmDeleteDialog(
        title: 'Delete Pet',
        message: 'Delete ${pet.name}?',
      ),
    );

    if (confirm == true) {
      await ref.read(petsProvider.notifier).deletePet(pet.id!);
    }
  }
}
