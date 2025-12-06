import 'package:floor/floor.dart';
import 'package:kalimati/core/entities/learning_package.dart';

@dao
abstract class LearningPackageDao {
  @Query("SELECT * FROM packages")
  Stream<List<LearningPackage>> getPackages();

  @Query("SELECT * FROM packages WHERE author =:authorId")
  Stream<List<LearningPackage>> getPackagesByAuthorId(String authorId);

  @insert
  Future<void> addPackage(LearningPackage package);

  @delete
  Future<void> deletePackage(LearningPackage package);

  @Query("SELECT * FROM packages WHERE packageId =:id")
  Future<LearningPackage?> getPackageById(String id);

  @update
  Future<void> updatePackage(LearningPackage package);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> upsertPackage(LearningPackage package);

  @insert
  Future<void> insertPackages(List<LearningPackage> packages);

  @Query("DELETE FROM packages")
  Future<void> deleteAllPackages();
}
