import 'package:floor/floor.dart';
import 'package:data_layer/features/pets/models/owner.dart';

@dao
abstract class OwnerDao {
  @Query('SELECT * FROM Owner ORDER BY name ASC')
  Future<List<Owner>> getAllOwners();

  @Query('SELECT * FROM Owner WHERE id = :id')
  Future<Owner?> getOwnerById(int id);

  @insert
  Future<int> insertOwner(Owner owner);

  @insert
  Future<List<int>> insertOwners(List<Owner> owners);

  @update
  Future<void> updateOwner(Owner owner);

  @delete
  Future<void> deleteOwner(Owner owner);

  @Query('DELETE FROM Owner WHERE id = :id')
  Future<void> deleteOwnerById(int id);

  @Query('DELETE FROM Owner')
  Future<void> deleteAllOwners();

  @Query('SELECT COUNT(*) FROM Owner')
  Future<int?> getOwnerCount();
}
