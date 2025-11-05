// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  TodoDao? _todoDaoInstance;

  OwnerDao? _ownerDaoInstance;

  PetDao? _petDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `todo` (`id` TEXT NOT NULL, `description` TEXT NOT NULL, `completed` INTEGER NOT NULL, `type` TEXT NOT NULL, `createdAt` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Owner` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Pet` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `ownerId` INTEGER NOT NULL, FOREIGN KEY (`ownerId`) REFERENCES `Owner` (`id`) ON UPDATE NO ACTION ON DELETE CASCADE)');
        await database
            .execute('CREATE INDEX `index_Pet_ownerId` ON `Pet` (`ownerId`)');
        await database.execute(
            'CREATE VIEW IF NOT EXISTS `PetWithOwnerView` AS SELECT p.name as petName, o.name as ownerName FROM Pet p INNER JOIN Owner o on p.ownerId = o.id');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TodoDao get todoDao {
    return _todoDaoInstance ??= _$TodoDao(database, changeListener);
  }

  @override
  OwnerDao get ownerDao {
    return _ownerDaoInstance ??= _$OwnerDao(database, changeListener);
  }

  @override
  PetDao get petDao {
    return _petDaoInstance ??= _$PetDao(database, changeListener);
  }
}

class _$TodoDao extends TodoDao {
  _$TodoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _todoInsertionAdapter = InsertionAdapter(
            database,
            'todo',
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'description': item.description,
                  'completed': item.completed ? 1 : 0,
                  'type': _todoTypeConverter.encode(item.type),
                  'createdAt': item.createdAtTimestamp
                },
            changeListener),
        _todoUpdateAdapter = UpdateAdapter(
            database,
            'todo',
            ['id'],
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'description': item.description,
                  'completed': item.completed ? 1 : 0,
                  'type': _todoTypeConverter.encode(item.type),
                  'createdAt': item.createdAtTimestamp
                },
            changeListener),
        _todoDeletionAdapter = DeletionAdapter(
            database,
            'todo',
            ['id'],
            (Todo item) => <String, Object?>{
                  'id': item.id,
                  'description': item.description,
                  'completed': item.completed ? 1 : 0,
                  'type': _todoTypeConverter.encode(item.type),
                  'createdAt': item.createdAtTimestamp
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Todo> _todoInsertionAdapter;

  final UpdateAdapter<Todo> _todoUpdateAdapter;

  final DeletionAdapter<Todo> _todoDeletionAdapter;

  @override
  Future<List<Todo>> getTodos() async {
    return _queryAdapter.queryList('SELECT * FROM todo ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => Todo(
            id: row['id'] as String,
            description: row['description'] as String,
            completed: (row['completed'] as int) != 0,
            type: _todoTypeConverter.decode(row['type'] as String)));
  }

  @override
  Stream<List<Todo>> observeTodos() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM todo ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => Todo(
            id: row['id'] as String,
            description: row['description'] as String,
            completed: (row['completed'] as int) != 0,
            type: _todoTypeConverter.decode(row['type'] as String)),
        queryableName: 'todo',
        isView: false);
  }

  @override
  Future<Todo?> getTodoById(String id) async {
    return _queryAdapter.query('SELECT * FROM todo WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Todo(
            id: row['id'] as String,
            description: row['description'] as String,
            completed: (row['completed'] as int) != 0,
            type: _todoTypeConverter.decode(row['type'] as String)),
        arguments: [id]);
  }

  @override
  Future<void> deleteTodoById(String id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM todo WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAllTodos() async {
    await _queryAdapter.queryNoReturn('DELETE FROM todo');
  }

  @override
  Future<int?> getTodosCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM todo',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<List<Todo>> searchTodos(
    String searchQuery,
    String typeFilter,
    int completedFilter,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM todo      WHERE (?1 = \'\' OR description LIKE \'%\' || ?1 || \'%\')     AND (?2 = \'\' OR type = ?2)     AND (?3 = -1 OR completed = ?3)     ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => Todo(id: row['id'] as String, description: row['description'] as String, completed: (row['completed'] as int) != 0, type: _todoTypeConverter.decode(row['type'] as String)),
        arguments: [searchQuery, typeFilter, completedFilter]);
  }

  @override
  Future<void> insertTodo(Todo todo) async {
    await _todoInsertionAdapter.insert(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTodos(List<Todo> todos) async {
    await _todoInsertionAdapter.insertList(todos, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await _todoUpdateAdapter.update(todo, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    await _todoDeletionAdapter.delete(todo);
  }
}

class _$OwnerDao extends OwnerDao {
  _$OwnerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _ownerInsertionAdapter = InsertionAdapter(
            database,
            'Owner',
            (Owner item) =>
                <String, Object?>{'id': item.id, 'name': item.name}),
        _ownerUpdateAdapter = UpdateAdapter(
            database,
            'Owner',
            ['id'],
            (Owner item) =>
                <String, Object?>{'id': item.id, 'name': item.name}),
        _ownerDeletionAdapter = DeletionAdapter(
            database,
            'Owner',
            ['id'],
            (Owner item) =>
                <String, Object?>{'id': item.id, 'name': item.name});

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Owner> _ownerInsertionAdapter;

  final UpdateAdapter<Owner> _ownerUpdateAdapter;

  final DeletionAdapter<Owner> _ownerDeletionAdapter;

  @override
  Future<List<Owner>> getAllOwners() async {
    return _queryAdapter.queryList('SELECT * FROM Owner ORDER BY name ASC',
        mapper: (Map<String, Object?> row) =>
            Owner(id: row['id'] as int?, name: row['name'] as String));
  }

  @override
  Future<Owner?> getOwnerById(int id) async {
    return _queryAdapter.query('SELECT * FROM Owner WHERE id = ?1',
        mapper: (Map<String, Object?> row) =>
            Owner(id: row['id'] as int?, name: row['name'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteOwnerById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Owner WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deleteAllOwners() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Owner');
  }

  @override
  Future<int?> getOwnerCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM Owner',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertOwner(Owner owner) {
    return _ownerInsertionAdapter.insertAndReturnId(
        owner, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertOwners(List<Owner> owners) {
    return _ownerInsertionAdapter.insertListAndReturnIds(
        owners, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateOwner(Owner owner) async {
    await _ownerUpdateAdapter.update(owner, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteOwner(Owner owner) async {
    await _ownerDeletionAdapter.delete(owner);
  }
}

class _$PetDao extends PetDao {
  _$PetDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _petInsertionAdapter = InsertionAdapter(
            database,
            'Pet',
            (Pet item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'ownerId': item.ownerId
                }),
        _petUpdateAdapter = UpdateAdapter(
            database,
            'Pet',
            ['id'],
            (Pet item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'ownerId': item.ownerId
                }),
        _petDeletionAdapter = DeletionAdapter(
            database,
            'Pet',
            ['id'],
            (Pet item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'ownerId': item.ownerId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Pet> _petInsertionAdapter;

  final UpdateAdapter<Pet> _petUpdateAdapter;

  final DeletionAdapter<Pet> _petDeletionAdapter;

  @override
  Future<List<Pet>> getAllPets() async {
    return _queryAdapter.queryList('SELECT * FROM Pet ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => Pet(
            id: row['id'] as int?,
            name: row['name'] as String,
            ownerId: row['ownerId'] as int));
  }

  @override
  Future<Pet?> getPetById(int id) async {
    return _queryAdapter.query('SELECT * FROM Pet WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Pet(
            id: row['id'] as int?,
            name: row['name'] as String,
            ownerId: row['ownerId'] as int),
        arguments: [id]);
  }

  @override
  Future<List<Pet>> getPetsByOwnerId(int ownerId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Pet WHERE ownerId = ?1 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => Pet(
            id: row['id'] as int?,
            name: row['name'] as String,
            ownerId: row['ownerId'] as int),
        arguments: [ownerId]);
  }

  @override
  Future<void> deletePetById(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM Pet WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> deletePetsByOwnerId(int ownerId) async {
    await _queryAdapter.queryNoReturn('DELETE FROM Pet WHERE ownerId = ?1',
        arguments: [ownerId]);
  }

  @override
  Future<void> deleteAllPets() async {
    await _queryAdapter.queryNoReturn('DELETE FROM Pet');
  }

  @override
  Future<int?> getPetCount() async {
    return _queryAdapter.query('SELECT COUNT(*) FROM Pet',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> getPetCountByOwnerId(int ownerId) async {
    return _queryAdapter.query('SELECT COUNT(*) FROM Pet WHERE ownerId = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [ownerId]);
  }

  @override
  Future<List<PetOwner>> getPetsWithOwners() async {
    return _queryAdapter.queryList('SELECT * FROM PetWithOwnerView',
        mapper: (Map<String, Object?> row) => PetOwner(
            petName: row['petName'] as String,
            ownerName: row['ownerName'] as String));
  }

  @override
  Future<int> insertPet(Pet pet) {
    return _petInsertionAdapter.insertAndReturnId(
        pet, OnConflictStrategy.abort);
  }

  @override
  Future<List<int>> insertPets(List<Pet> pets) {
    return _petInsertionAdapter.insertListAndReturnIds(
        pets, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePet(Pet pet) async {
    await _petUpdateAdapter.update(pet, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePet(Pet pet) async {
    await _petDeletionAdapter.delete(pet);
  }
}

// ignore_for_file: unused_element
final _todoTypeConverter = TodoTypeConverter();
