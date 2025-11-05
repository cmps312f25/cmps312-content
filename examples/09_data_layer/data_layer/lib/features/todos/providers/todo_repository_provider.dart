import 'package:data_layer/features/todos/repositories/todo_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/app/providers/database_provider.dart';


// Repository provider that depends on the database
final todoRepositoryProvider = FutureProvider<TodoRepository>((ref) async {
  // Wait for database to be ready
  final database = await ref.watch(databaseProvider.future);
  return TodoRepository(database.todoDao);
});
