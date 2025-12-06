import 'package:kalimati/core/data/daos/learning_package_dao.dart';
import 'package:kalimati/core/repositories/learning_package_repo.dart';
import 'package:kalimati/core/entities/learning_package.dart';

class LearningPackageLocalDb implements LearningPackageRepo {
  final LearningPackageDao _packageDao;

  LearningPackageLocalDb(this._packageDao);

  @override
  Future<void> addPackage(LearningPackage learningPackage) =>
      _packageDao.addPackage(learningPackage);

  @override
  Future<void> deletePackage(LearningPackage learningPackage) =>
      _packageDao.deletePackage(learningPackage);

  @override
  Stream<List<LearningPackage>> getPackages() => _packageDao.getPackages();

  @override
  Stream<List<LearningPackage>> getPackagesByAuthorId(String authorId) =>
      _packageDao.getPackagesByAuthorId(authorId);

  @override
  Future<LearningPackage?> getPackageById(String id) =>
      _packageDao.getPackageById(id);

  @override
  Future<void> updatePackage(LearningPackage learningPackage) =>
      _packageDao.updatePackage(learningPackage);
}
