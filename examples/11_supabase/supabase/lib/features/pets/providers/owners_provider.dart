import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app/features/pets/models/owner.dart';
import 'package:supabase_app/features/pets/providers/owner_repository_provider.dart';

/// AsyncNotifier for managing owners list
class OwnersNotifier extends AsyncNotifier<List<Owner>> {
  @override
  Future<List<Owner>> build() async {
    final repository = ref.watch(ownerRepositoryProvider);
    return await repository.getAllOwners();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }

  Future<void> addOwner(String firstName, String lastName) async {
    final repository = ref.read(ownerRepositoryProvider);
    await repository.addOwner(Owner(firstName: firstName, lastName: lastName));
    await refresh();
  }

  Future<void> deleteOwner(int id) async {
    final repository = ref.read(ownerRepositoryProvider);
    await repository.deleteOwner(id);
    await refresh();
  }
}

final ownersProvider = AsyncNotifierProvider<OwnersNotifier, List<Owner>>(
  () => OwnersNotifier(),
);
