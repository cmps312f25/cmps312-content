# Shared Database Architecture

## Overview
The app uses a **shared database** approach where all features access a single Floor database instance through a centralized provider.

## Structure

```
lib/
├── app/
│   ├── database/
│   │   ├── app_database.dart       # Shared database definition
│   │   └── app_database.g.dart     # Generated Floor code
│   └── providers/
│       └── database_provider.dart  # Shared database provider
├── features/
│   ├── todos/
│   │   ├── database/
│   │   │   └── todo_dao.dart       # Todo-specific DAO
│   │   ├── models/
│   │   │   └── todo.dart           # Todo entity
│   │   └── providers/
│   │       └── database_provider.dart  # Re-exports shared provider
│   └── pets/
│       ├── database/
│       │   ├── owner_dao.dart      # Owner-specific DAO
│       │   └── pet_dao.dart        # Pet-specific DAO
│       ├── models/
│       │   ├── owner.dart          # Owner entity
│       │   └── pet.dart            # Pet entity (with FK to Owner)
│       └── providers/
│           └── pet_repository_provider.dart
```

## Key Benefits

### ✅ Single Source of Truth
- One database instance for the entire app
- All entities and relationships in one place
- Consistent data access patterns

### ✅ Feature Isolation
- Each feature has its own DAOs
- Each feature has its own models
- Features can be developed independently

## Adding a New Feature

To add a new feature with database support:

1. **Create models** in `lib/features/your_feature/models/`
2. **Create DAOs** in `lib/features/your_feature/database/`
3. **Update app_database.dart** to include new entities and DAOs
4. **Run build_runner**: `dart run build_runner build --delete-conflicting-outputs`
5. **Create repository** to encapsulate database operations
6. **Create repository provider** that watches `databaseProvider`


## Best Practices

1. ✅ **Keep database definition in `/app/database/`** - shared by all features
2. ✅ **Keep DAOs feature-specific** - in each feature's `database/` folder
3. ✅ **Keep models feature-specific** - in each feature's `models/` folder
4. ✅ **Use repository pattern** - encapsulate database operations
5. ✅ **Initialize test data centrally** - in the shared database provider
6. ✅ **Use foreign keys** - for data integrity
7. ✅ **Add indices** - for foreign keys to improve query performance
