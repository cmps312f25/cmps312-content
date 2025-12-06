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

  LearningPackageDao? _learningPackageDaoInstance;

  UserDao? _userDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
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
            'CREATE TABLE IF NOT EXISTS `packages` (`packageId` TEXT NOT NULL, `author` TEXT NOT NULL, `category` TEXT NOT NULL, `description` TEXT NOT NULL, `iconUrl` TEXT NOT NULL, `keyWords` TEXT, `language` TEXT NOT NULL, `lastUpdateDate` TEXT NOT NULL, `level` TEXT NOT NULL, `title` TEXT NOT NULL, `version` INTEGER NOT NULL, `words` TEXT NOT NULL, PRIMARY KEY (`packageId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` TEXT NOT NULL, `firstName` TEXT NOT NULL, `lastName` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL, `photoUrl` TEXT NOT NULL, `role` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  LearningPackageDao get learningPackageDao {
    return _learningPackageDaoInstance ??=
        _$LearningPackageDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }
}

class _$LearningPackageDao extends LearningPackageDao {
  _$LearningPackageDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _learningPackageInsertionAdapter = InsertionAdapter(
            database,
            'packages',
            (LearningPackage item) => <String, Object?>{
                  'packageId': item.packageId,
                  'author': item.author,
                  'category': item.category,
                  'description': item.description,
                  'iconUrl': item.iconUrl,
                  'keyWords': _stringListConverter.encode(item.keyWords),
                  'language': item.language,
                  'lastUpdateDate':
                      _dateTimeConverter.encode(item.lastUpdateDate),
                  'level': item.level,
                  'title': item.title,
                  'version': item.version,
                  'words': _wordListConverter.encode(item.words)
                },
            changeListener),
        _learningPackageUpdateAdapter = UpdateAdapter(
            database,
            'packages',
            ['packageId'],
            (LearningPackage item) => <String, Object?>{
                  'packageId': item.packageId,
                  'author': item.author,
                  'category': item.category,
                  'description': item.description,
                  'iconUrl': item.iconUrl,
                  'keyWords': _stringListConverter.encode(item.keyWords),
                  'language': item.language,
                  'lastUpdateDate':
                      _dateTimeConverter.encode(item.lastUpdateDate),
                  'level': item.level,
                  'title': item.title,
                  'version': item.version,
                  'words': _wordListConverter.encode(item.words)
                },
            changeListener),
        _learningPackageDeletionAdapter = DeletionAdapter(
            database,
            'packages',
            ['packageId'],
            (LearningPackage item) => <String, Object?>{
                  'packageId': item.packageId,
                  'author': item.author,
                  'category': item.category,
                  'description': item.description,
                  'iconUrl': item.iconUrl,
                  'keyWords': _stringListConverter.encode(item.keyWords),
                  'language': item.language,
                  'lastUpdateDate':
                      _dateTimeConverter.encode(item.lastUpdateDate),
                  'level': item.level,
                  'title': item.title,
                  'version': item.version,
                  'words': _wordListConverter.encode(item.words)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LearningPackage> _learningPackageInsertionAdapter;

  final UpdateAdapter<LearningPackage> _learningPackageUpdateAdapter;

  final DeletionAdapter<LearningPackage> _learningPackageDeletionAdapter;

  @override
  Stream<List<LearningPackage>> getPackages() {
    return _queryAdapter.queryListStream('SELECT * FROM packages',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String,
            keyWords: _stringListConverter.decode(row['keyWords'] as String?),
            language: row['language'] as String,
            lastUpdateDate:
                _dateTimeConverter.decode(row['lastUpdateDate'] as String),
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as int,
            words: _wordListConverter.decode(row['words'] as String)),
        queryableName: 'packages',
        isView: false);
  }

  @override
  Stream<List<LearningPackage>> getPackagesByAuthorId(String authorId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM packages WHERE author =?1',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String,
            keyWords: _stringListConverter.decode(row['keyWords'] as String?),
            language: row['language'] as String,
            lastUpdateDate:
                _dateTimeConverter.decode(row['lastUpdateDate'] as String),
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as int,
            words: _wordListConverter.decode(row['words'] as String)),
        arguments: [authorId],
        queryableName: 'packages',
        isView: false);
  }

  @override
  Future<LearningPackage?> getPackageById(String id) async {
    return _queryAdapter.query('SELECT * FROM packages WHERE packageId =?1',
        mapper: (Map<String, Object?> row) => LearningPackage(
            packageId: row['packageId'] as String,
            author: row['author'] as String,
            category: row['category'] as String,
            description: row['description'] as String,
            iconUrl: row['iconUrl'] as String,
            keyWords: _stringListConverter.decode(row['keyWords'] as String?),
            language: row['language'] as String,
            lastUpdateDate:
                _dateTimeConverter.decode(row['lastUpdateDate'] as String),
            level: row['level'] as String,
            title: row['title'] as String,
            version: row['version'] as int,
            words: _wordListConverter.decode(row['words'] as String)),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllPackages() async {
    await _queryAdapter.queryNoReturn('DELETE FROM packages');
  }

  @override
  Future<void> addPackage(LearningPackage package) async {
    await _learningPackageInsertionAdapter.insert(
        package, OnConflictStrategy.abort);
  }

  @override
  Future<void> upsertPackage(LearningPackage package) async {
    await _learningPackageInsertionAdapter.insert(
        package, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertPackages(List<LearningPackage> packages) async {
    await _learningPackageInsertionAdapter.insertList(
        packages, OnConflictStrategy.abort);
  }

  @override
  Future<void> updatePackage(LearningPackage package) async {
    await _learningPackageUpdateAdapter.update(
        package, OnConflictStrategy.abort);
  }

  @override
  Future<void> deletePackage(LearningPackage package) async {
    await _learningPackageDeletionAdapter.delete(package);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'firstName': item.firstName,
                  'lastName': item.lastName,
                  'email': item.email,
                  'password': item.password,
                  'photoUrl': item.photoUrl,
                  'role': item.role
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  @override
  Stream<List<User>> getUsers() {
    return _queryAdapter.queryListStream('SELECT * FROM users',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            photoUrl: row['photoUrl'] as String,
            role: row['role'] as String),
        queryableName: 'users',
        isView: false);
  }

  @override
  Future<User?> getUserById(String id) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email =?1',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            photoUrl: row['photoUrl'] as String,
            role: row['role'] as String),
        arguments: [id]);
  }

  @override
  Future<User?> getUserByEmailAndPassword(
    String email,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM users WHERE email = ?1 AND password = ?2',
        mapper: (Map<String, Object?> row) => User(
            id: row['id'] as String,
            firstName: row['firstName'] as String,
            lastName: row['lastName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            photoUrl: row['photoUrl'] as String,
            role: row['role'] as String),
        arguments: [email, password]);
  }

  @override
  Future<void> clearUsers() async {
    await _queryAdapter.queryNoReturn('DELETE FROM users');
  }

  @override
  Future<void> insertUsers(List<User> users) async {
    await _userInsertionAdapter.insertList(users, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _wordListConverter = WordListConverter();
final _stringListConverter = StringListConverter();
final _dateTimeConverter = DateTimeConverter();
