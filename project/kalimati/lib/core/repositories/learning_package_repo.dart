import 'package:kalimati/core/entities/learning_package.dart';

abstract class LearningPackageRepo {
  Future<void> addPackage(LearningPackage learningPackage);

  Future<void> deletePackage(LearningPackage learningPackage);

  Stream<List<LearningPackage>> getPackages();

  Stream<List<LearningPackage>> getPackagesByAuthorId(String authorId);

  Future<LearningPackage?> getPackageById(String id);

  Future<void> updatePackage(LearningPackage learningPackage);
}
