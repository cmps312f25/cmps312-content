import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/app/providers/database_provider.dart';
import 'package:data_layer/features/pets/repositories/pet_repository.dart';

// Repository provider that depends on the database
final petRepositoryProvider = FutureProvider<PetRepository>((ref) async {
  // Wait for database to be ready
  final database = await ref.watch(databaseProvider.future);
  return PetRepository(database.ownerDao, database.petDao);
});
