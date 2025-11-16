import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_app/features/pets/models/owner.dart';
import 'package:supabase_app/features/pets/models/pet.dart';
import 'package:supabase_app/features/pets/models/pet_owner.dart';

class PetRepository {
  final SupabaseClient _client;

  PetRepository(this._client);

  // ==================== Owner Operations ====================

  Future<List<Owner>> getAllOwners() async {
    final response = await _client
        .from('owners')
        .select()
        .order('name', ascending: true);
    return (response as List).map((json) => Owner.fromJson(json)).toList();
  }

  Future<Owner?> getOwnerById(int id) async {
    final response = await _client
        .from('owners')
        .select()
        .eq('id', id)
        .maybeSingle();
    return response != null ? Owner.fromJson(response) : null;
  }

  Future<int> addOwner(Owner owner) async {
    final response = await _client
        .from('owners')
        .insert(owner.toJson())
        .select()
        .single();
    return response['id'] as int;
  }

  Future<void> updateOwner(Owner owner) async {
    await _client.from('owners').update(owner.toJson()).eq('id', owner.id!);
  }

  Future<void> deleteOwner(int id) async {
    await _client.from('owners').delete().eq('id', id);
  }

  Future<int> getOwnerCount() async {
    final response = await _client
        .from('owners')
        .select()
        .count(CountOption.exact);
    return response.count;
  }

  // ==================== Pet Operations ====================

  Future<List<Pet>> getAllPets() async {
    final response = await _client
        .from('pets')
        .select()
        .order('name', ascending: true);
    return (response as List).map((json) => Pet.fromJson(json)).toList();
  }

  Future<Pet?> getPetById(int id) async {
    final response = await _client
        .from('pets')
        .select()
        .eq('id', id)
        .maybeSingle();
    return response != null ? Pet.fromJson(response) : null;
  }

  Future<List<Pet>> getPetsByOwnerId(int ownerId) async {
    final response = await _client
        .from('pets')
        .select()
        .eq('owner_id', ownerId)
        .order('name', ascending: true);
    return (response as List).map((json) => Pet.fromJson(json)).toList();
  }

  Future<int> addPet(Pet pet) async {
    final response = await _client
        .from('pets')
        .insert(pet.toJson())
        .select()
        .single();
    return response['id'] as int;
  }

  Future<void> updatePet(Pet pet) async {
    await _client.from('pets').update(pet.toJson()).eq('id', pet.id!);
  }

  Future<void> deletePet(int id) async {
    await _client.from('pets').delete().eq('id', id);
  }

  Future<int> getPetCount() async {
    final response = await _client
        .from('pets')
        .select()
        .count(CountOption.exact);
    return response.count;
  }

  Future<int> getPetCountByOwnerId(int ownerId) async {
    final response = await _client
        .from('pets')
        .select()
        .eq('owner_id', ownerId)
        .count(CountOption.exact);
    return response.count;
  }

  // ==================== Combined Operations ====================

  Future<List<PetOwner>> getPetsWithOwners() async {
    final response = await _client.from('pet_owner_view').select();
    return (response as List).map((json) => PetOwner.fromJson(json)).toList();
  }

  // ==================== Initialization ====================

  Future<void> initializeWithTestData() async {
    final count = await getOwnerCount();
    if (count == 0) {
      // Insert owners
      final owner1Id = await addOwner(Owner(name: 'John Doe'));
      final owner2Id = await addOwner(Owner(name: 'Jane Smith'));
      final owner3Id = await addOwner(Owner(name: 'Samir Saghir'));

      // Insert pets for each owner
      await Future.wait([
        addPet(Pet(name: 'Max', ownerId: owner1Id)),
        addPet(Pet(name: 'Buddy', ownerId: owner1Id)),
        addPet(Pet(name: 'Luna', ownerId: owner2Id)),
        addPet(Pet(name: 'Charlie', ownerId: owner2Id)),
        addPet(Pet(name: 'Bella', ownerId: owner2Id)),
        addPet(Pet(name: 'Rocky', ownerId: owner3Id)),
      ]);
    }
  }
}
