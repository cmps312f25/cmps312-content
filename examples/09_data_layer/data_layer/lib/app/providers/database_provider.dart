import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:floor/floor.dart';
import 'package:data_layer/app/database/app_database.dart';
import 'package:data_layer/features/todos/repositories/todo_repository.dart';
import 'package:data_layer/features/pets/repositories/pet_repository.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Shared database provider - initialized once and cached
/// All features access the database through this provider
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  // Print database path for debugging
  final dbPath = await databaseFactoryFfi.getDatabasePath('app_database.db');
  print('Database path: $dbPath');

  // ToDo: in case of major schema changes or db issues in development
  // simply comment out the following lines to keep the existing database
  try {
    await databaseFactoryFfi.deleteDatabase('app_database.db');
    print('✓ Database deleted successfully - will create fresh database');
  } catch (e) {
    print('Note: No existing database to delete (this is normal on first run)');
  }

  final database = await $FloorAppDatabase
      .databaseBuilder('app_database.db')
      .addCallback(
        Callback(
          onCreate: (database, version) async {
            // Tables and views are auto-created by Floor
          },
          /*           onOpen: (database) async {
            // Ensure the view exists every time the database is opened
            // This handles cases where the database was created with an older version
            await database.execute(
              'CREATE VIEW IF NOT EXISTS PetWithOwnerView AS '
              'SELECT p.name as petName, o.name as ownerName '
              'FROM Pet p INNER JOIN Owner o on p.ownerId = o.id',
            );
          }, */
          onUpgrade: (database, startVersion, endVersion) async {
            // Drop all tables - Floor will recreate them automatically after this callback
            await database.execute('DROP TABLE IF EXISTS Pet');
            await database.execute('DROP TABLE IF EXISTS Owner');
            await database.execute('DROP TABLE IF EXISTS todo');
            await database.execute('DROP VIEW IF EXISTS PetWithOwnerView');
          },
        ),
      )
      .build();

  // Initialize with test data if empty
  final todoRepository = TodoRepository(database.todoDao);
  await todoRepository.initializeWithTestData();

  final petRepository = PetRepository(database.ownerDao, database.petDao);
  await petRepository.initializeWithTestData();

  return database;
});
