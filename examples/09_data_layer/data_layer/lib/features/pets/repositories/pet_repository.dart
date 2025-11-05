import 'package:data_layer/features/pets/models/owner.dart';
import 'package:data_layer/features/pets/models/pet.dart';
import 'package:data_layer/features/pets/models/pet_owner.dart';
import 'package:data_layer/features/pets/daos/owner_dao.dart';
import 'package:data_layer/features/pets/daos/pet_dao.dart';

class PetRepository {
  final OwnerDao _ownerDao;
  final PetDao _petDao;

  PetRepository(this._ownerDao, this._petDao);

  // Owner operations
  Future<List<Owner>> getAllOwners() => _ownerDao.getAllOwners();

  Future<Owner?> getOwnerById(int id) => _ownerDao.getOwnerById(id);

  Future<int> addOwner(Owner owner) => _ownerDao.insertOwner(owner);

  Future<void> updateOwner(Owner owner) => _ownerDao.updateOwner(owner);

  Future<void> deleteOwner(int id) => _ownerDao.deleteOwnerById(id);

  Future<int> getOwnerCount() async {
    return await _ownerDao.getOwnerCount() ?? 0;
  }

  // Pet operations
  Future<List<Pet>> getAllPets() => _petDao.getAllPets();

  Future<Pet?> getPetById(int id) => _petDao.getPetById(id);

  Future<List<Pet>> getPetsByOwnerId(int ownerId) =>
      _petDao.getPetsByOwnerId(ownerId);

  Future<int> addPet(Pet pet) => _petDao.insertPet(pet);

  Future<void> updatePet(Pet pet) => _petDao.updatePet(pet);

  Future<void> deletePet(int id) => _petDao.deletePetById(id);

  Future<int> getPetCount() async {
    return await _petDao.getPetCount() ?? 0;
  }

  Future<int> getPetCountByOwnerId(int ownerId) async {
    return await _petDao.getPetCountByOwnerId(ownerId) ?? 0;
  }

  // Get pets with owners (from database view)
  Future<List<PetOwner>> getPetsWithOwners() => _petDao.getPetsWithOwners();

  // Initialize with test data
  Future<void> initializeWithTestData() async {
    final count = await getOwnerCount();
    if (count == 0) {
      // Insert owners
      final owner1Id = await _ownerDao.insertOwner(Owner(name: 'John Doe'));
      final owner2Id = await _ownerDao.insertOwner(Owner(name: 'Jane Smith'));
      final owner3Id = await _ownerDao.insertOwner(Owner(name: 'Samir Saghir'));

      // Insert pets for each owner
      await _petDao.insertPets([
        Pet(name: 'Max', ownerId: owner1Id),
        Pet(name: 'Buddy', ownerId: owner1Id),
        Pet(name: 'Luna', ownerId: owner2Id),
        Pet(name: 'Charlie', ownerId: owner2Id),
        Pet(name: 'Bella', ownerId: owner2Id),
        Pet(name: 'Rocky', ownerId: owner3Id),
      ]);
    }
  }
}
