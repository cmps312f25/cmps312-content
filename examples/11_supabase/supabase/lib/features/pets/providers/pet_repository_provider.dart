import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app/app/providers/database_provider.dart';
import 'package:supabase_app/features/pets/repositories/pet_repository.dart';

// Repository provider that depends on the Supabase client
final petRepositoryProvider = Provider<PetRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return PetRepository(client);
});
