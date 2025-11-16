import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_app/features/todos/repositories/todo_repository.dart';
import 'package:supabase_app/features/pets/repositories/pet_repository.dart';

/// Supabase client provider - initialized once and cached
/// All features access the database through this provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Initialize Supabase and test data
final databaseInitializerProvider = FutureProvider<void>((ref) async {
  final client = ref.watch(supabaseClientProvider);

  // Initialize with test data if empty
  final todoRepository = TodoRepository(client);
  await todoRepository.initializeWithTestData();

  final petRepository = PetRepository(client);
  await petRepository.initializeWithTestData();
});
