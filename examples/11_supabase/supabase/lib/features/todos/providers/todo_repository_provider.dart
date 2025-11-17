import 'package:supabase_app/features/todos/repositories/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_app/app/providers/supabase_client_provider.dart';

// Repository provider that depends on the Supabase client
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return TodoRepository(client);
});
