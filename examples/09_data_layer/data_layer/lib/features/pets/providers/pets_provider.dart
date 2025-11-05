import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/pets/models/pet.dart';
import 'package:data_layer/features/pets/models/pet_owner.dart';
import 'package:data_layer/features/pets/providers/pet_repository_provider.dart';

/// Notifier for selected owner ID
class SelectedOwnerNotifier extends Notifier<int?> {
  @override
  int? build() => null;

  void selectOwner(int? ownerId) => state = ownerId;
}

final selectedOwnerIdProvider = NotifierProvider<SelectedOwnerNotifier, int?>(
  () => SelectedOwnerNotifier(),
);

/// AsyncNotifier for managing pets for a selected owner
class PetsNotifier extends AsyncNotifier<List<Pet>> {
  @override
  Future<List<Pet>> build() async {
    final ownerId = ref.watch(selectedOwnerIdProvider);
    final repository = await ref.watch(petRepositoryProvider.future);

    if (ownerId == null) {
      return [];
    }

    return await repository.getPetsByOwnerId(ownerId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> addPet(String name, int ownerId) async {
    final repository = await ref.read(petRepositoryProvider.future);
    await repository.addPet(Pet(name: name, ownerId: ownerId));
    await refresh();
  }

  Future<void> deletePet(int id) async {
    final repository = await ref.read(petRepositoryProvider.future);
    await repository.deletePet(id);
    await refresh();
  }
}

final petsProvider = AsyncNotifierProvider<PetsNotifier, List<Pet>>(
  () => PetsNotifier(),
);

/// Provider for pets with owners (database view)
final petsWithOwnersProvider = FutureProvider<List<PetOwner>>((ref) async {
  final repository = await ref.watch(petRepositoryProvider.future);
  return await repository.getPetsWithOwners();
});
