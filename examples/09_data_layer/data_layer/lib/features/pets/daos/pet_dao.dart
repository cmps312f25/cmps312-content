import 'package:data_layer/features/pets/models/pet_owner.dart';
import 'package:floor/floor.dart';
import 'package:data_layer/features/pets/models/pet.dart';

@dao
abstract class PetDao {
  @Query('SELECT * FROM Pet ORDER BY name ASC')
  Future<List<Pet>> getAllPets();

  @Query('SELECT * FROM Pet WHERE id = :id')
  Future<Pet?> getPetById(int id);

  @Query('SELECT * FROM Pet WHERE ownerId = :ownerId ORDER BY name ASC')
  Future<List<Pet>> getPetsByOwnerId(int ownerId);

  @insert
  Future<int> insertPet(Pet pet);

  @insert
  Future<List<int>> insertPets(List<Pet> pets);

  @update
  Future<void> updatePet(Pet pet);

  @delete
  Future<void> deletePet(Pet pet);

  @Query('DELETE FROM Pet WHERE id = :id')
  Future<void> deletePetById(int id);

  @Query('DELETE FROM Pet WHERE ownerId = :ownerId')
  Future<void> deletePetsByOwnerId(int ownerId);

  @Query('DELETE FROM Pet')
  Future<void> deleteAllPets();

  @Query('SELECT COUNT(*) FROM Pet')
  Future<int?> getPetCount();

  @Query('SELECT COUNT(*) FROM Pet WHERE ownerId = :ownerId')
  Future<int?> getPetCountByOwnerId(int ownerId);

  @Query('SELECT * FROM PetWithOwnerView')
  Future<List<PetOwner>> getPetsWithOwners();
}
