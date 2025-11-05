import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/pets/models/owner.dart';
import 'package:data_layer/features/pets/providers/pet_repository_provider.dart';

/// AsyncNotifier for managing owners list
class OwnersNotifier extends AsyncNotifier<List<Owner>> {
  @override
  Future<List<Owner>> build() async {
    final repository = await ref.watch(petRepositoryProvider.future);
    return await repository.getAllOwners();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> addOwner(String name) async {
    final repository = await ref.read(petRepositoryProvider.future);
    await repository.addOwner(Owner(name: name));
    await refresh();
  }

  Future<void> deleteOwner(int id) async {
    final repository = await ref.read(petRepositoryProvider.future);
    await repository.deleteOwner(id);
    await refresh();
  }
}

final ownersProvider = AsyncNotifierProvider<OwnersNotifier, List<Owner>>(
  () => OwnersNotifier(),
);
