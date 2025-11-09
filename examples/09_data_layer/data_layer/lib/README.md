# Shared Database Architecture

## Overview
The app uses a **shared Floor database** where all features access a single SQLite database instance through a centralized provider. Features use Riverpod for state management with database-level filtering.

## Structure

```
lib/
├── app/
│   ├── database/
│   │   ├── app_database.dart       # Shared database definition (entities, views, DAOs)
│   │   └── app_database.g.dart     # Generated Floor code
│   └── providers/
│       └── database_provider.dart  # Shared database instance provider
├── features/
│   ├── todos/
│   │   ├── database/
│   │   │   └── todo_dao.dart       # Todo DAO with search queries
│   │   ├── models/
│   │   │   └── todo.dart           # Todo entity
│   │   ├── providers/
│   │   │   ├── todo_repository_provider.dart    # Repository provider
│   │   │   ├── search_query_provider.dart       # Search text state
│   │   │   ├── type_filter_provider.dart        # Type filter state
│   │   │   ├── todo_filter_provider.dart        # Completion status filter
│   │   │   └── filtered_todos_provider.dart     # Database-filtered results
│   │   ├── repositories/
│   │   │   └── todo_repository.dart             # Business logic layer
│   │   ├── screens/
│   │   │   └── todo_screen.dart                 # Main UI with SearchBar
│   │   └── widgets/
│   └── pets/
│       ├── database/
│       │   ├── owner_dao.dart      # Owner DAO
│       │   └── pet_dao.dart        # Pet DAO (with JOIN query)
│       ├── models/
│       │   ├── owner.dart          # Owner entity
│       │   ├── pet.dart            # Pet entity (FK to Owner)
│       │   └── pet_owner.dart      # DatabaseView for JOIN
│       ├── providers/
│       │   ├── pet_repository_provider.dart
│       │   └── pets_provider.dart               # FutureProvider for pets with owners
│       ├── repositories/
│       │   └── pet_repository.dart
│       ├── screens/
│       │   └── pets_screen.dart                 # Pets Summary feature
│       └── widgets/
│           ├── add_pet_dialog.dart
│           ├── add_owner_dialog.dart
│           ├── pets_summary_dialog.dart         # Shows database view data
│           └── confirm_delete_dialog.dart       # Reusable dialog
```

## Key Features

### ✅ Shared Database Pattern
- Single Floor database instance for entire app
- All entities, views, and relationships centralized in `app_database.dart`
- Database version: 4 (includes PetWithOwnerView)

### ✅ Database-Level Filtering
- Efficient SQL queries instead of client-side filtering
- Search by description, type, and completion status
- Multiple DAO methods for different filter combinations

### ✅ Database Views
- `@DatabaseView` for complex JOIN queries
- `PetWithOwnerView` joins Pet and Owner tables
- Displayed via `FutureProvider` (compatible with Windows/sqflite_ffi)

### ✅ Feature Isolation
- Each feature owns its models, DAOs, repositories, and providers
- Features can be developed and tested independently
- Shared database provider used via dependency injection

## Navigation & State Management

- **GoRouter**: Declarative routing with `context.pop()`
- **Riverpod**: State management with NotifierProvider, AsyncNotifierProvider, FutureProvider
- **SearchBar**: Material 3 widget in app bar for inline search
- **Repository Pattern**: Encapsulates database operations and business logic

## Windows Desktop Considerations

⚠️ **Observable Queries**: Floor's `@Query` streams don't work reliably on Windows with `sqflite_common_ffi`. 
**Solution**: Use `FutureProvider` with manual `ref.invalidate()` instead of `StreamProvider`.

## Database Management

**Delete Database** (for schema changes):
```dart
// In database_provider.dart, uncomment:
await databaseFactoryFfi.deleteDatabase('app_database.db');
```

**Regenerate Floor Code**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Best Practices

1. ✅ **Database definition in `/app/database/`** - single source of truth
2. ✅ **DAOs are feature-specific** - in `features/*/database/`
3. ✅ **Repository pattern** - abstracts database operations from UI
4. ✅ **Database-level filtering** - efficient SQL queries via DAOs
5. ✅ **Use FutureProvider on Windows** - streams don't auto-update with sqflite_ffi
6. ✅ **Foreign keys with CASCADE DELETE** - maintain referential integrity
7. ✅ **Indices on foreign keys** - improve JOIN query performance
8. ✅ **GoRouter for navigation** - consistent navigation with context.pop()
9. ✅ **Reusable components** - extract dialogs for consistency
