import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:data_layer/features/todos/database/app_database.dart';
import 'package:data_layer/features/todos/repositories/todo_repository.dart';

// Database provider - initialized once and cached
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .build();

  // Initialize with test data if empty
  final repository = TodoRepository(database.todoDao);
  await repository.initializeWithTestData();

  return database;
});

// Repository provider that depends on the database
final todoRepositoryProvider = Provider<TodoRepository>((ref) {
  // Wait for database to be ready
  final databaseAsync = ref.watch(databaseProvider);

  return databaseAsync.when(
    data: (database) => TodoRepository(database.todoDao),
    loading: () => throw Exception('Database is loading...'),
    error: (error, stack) => throw Exception('Database error: $error'),
  );
});
