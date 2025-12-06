import 'package:kalimati/core/providers/database_provider.dart';
import 'package:kalimati/core/repositories/learning_package_local_db.dart';
import 'package:kalimati/core/repositories/learning_package_repo.dart';
import 'package:riverpod/riverpod.dart';

final packageRepoProvider = FutureProvider<LearningPackageRepo>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return LearningPackageLocalDb(db.learningPackageDao);
});
