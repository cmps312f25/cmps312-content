import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_app/features/pets/models/pet.dart';
import 'package:supabase_app/features/pets/providers/pets_provider.dart';
import 'package:supabase_app/features/pets/providers/pet_repository_provider.dart';
import 'package:supabase_app/features/pets/providers/image_picker_service_provider.dart';
import 'package:supabase_app/features/pets/widgets/add_pet_dialog.dart';
import 'package:supabase_app/features/pets/widgets/confirm_delete_dialog.dart';

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
      padding: const EdgeInsets.all(8),
      itemCount: pets.length,
      itemBuilder: (context, index) {
        final pet = pets[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Pet Image
                _buildPetImage(context, ref, pet),
                const SizedBox(width: 16),

                // Pet Name
                Expanded(
                  child: Text(
                    pet.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Upload Image Button
                IconButton(
                  icon: const Icon(Icons.add_a_photo),
                  color: Colors.blue,
                  tooltip: 'Upload Image',
                  onPressed: () => _handleUploadImage(context, ref, pet),
                ),

                // Delete Button
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.red,
                  tooltip: 'Delete Pet',
                  onPressed: () => _handleDeletePet(context, ref, pet),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPetImage(BuildContext context, WidgetRef ref, Pet pet) {
    if (pet.imagePath != null) {
      final repository = ref.read(petRepositoryProvider);
      final imageUrl = repository.getPetImageUrl(pet.imagePath!);

      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return const SizedBox(
              width: 60,
              height: 60,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          },
        ),
      );
    }

    return _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.pets, color: Colors.grey, size: 32),
    );
  }

  Future<void> _handleUploadImage(
    BuildContext context,
    WidgetRef ref,
    Pet pet,
  ) async {
    bool isDialogOpen = false;

    try {
      // Pick image using platform-aware service
      final imagePickerService = ref.read(imagePickerServiceProvider);
      final imageFile = await imagePickerService.pickImage();

      if (imageFile == null) return;

      // Show loading indicator
      if (context.mounted) {
        isDialogOpen = true;
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      }

      final repository = ref.read(petRepositoryProvider);

      // Delete old image if exists
      if (pet.imagePath != null) {
        await repository.deletePetImage(pet.imagePath!);
      }

      // Upload new image
      final imagePath = await repository.uploadPetImage(pet.id!, imageFile);

      // Update pet with new image path
      await repository.updatePetImage(pet.id!, imagePath);

      // Refresh pets list
      await ref.read(petsProvider.notifier).refreshPets();

      // Close loading dialog and show success
      if (context.mounted && isDialogOpen) {
        context.pop(); // Use go_router's pop
        isDialogOpen = false;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image uploaded successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close loading dialog if open and show error
      if (context.mounted && isDialogOpen) {
        context.pop(); // Use go_router's pop
        isDialogOpen = false;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
