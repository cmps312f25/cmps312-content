# Riverpod Provider Architecture

## Overview
This project uses **Riverpod** for state management with a layered architecture: Database → Repository → Providers → UI. Providers communicate through dependency watching (`ref.watch`) creating a reactive data flow.

## Provider Communication Flow

```
┌─────────────────────────────────────────────────────────────┐
│                     UI Layer (Widgets)                      │
│  - ConsumerWidget watches providers                         │
│  - Reads notifiers to update state                          │
│  - Displays AsyncValue states (loading/data/error)          │
└────────────────────┬────────────────────────────────────────┘
                     │ ref.watch()
┌────────────────────▼────────────────────────────────────────┐
│              State Providers (Notifiers)                    │
│  - Manage UI state (search, filters, selections)           │
│  - Provide simple state updates                             │
└────────────────────┬────────────────────────────────────────┘
                     │ ref.watch()
┌────────────────────▼────────────────────────────────────────┐
│         Computed Providers (AsyncNotifier/Future)           │
│  - Watch state providers and repository providers          │
│  - Perform database queries with filters                    │
│  - Return computed/filtered data                            │
└────────────────────┬────────────────────────────────────────┘
                     │ ref.watch()
┌────────────────────▼────────────────────────────────────────┐
│            Repository Providers (Future)                    │
│  - Watch database provider                                  │
│  - Provide business logic layer                             │
│  - Expose DAOs through repositories                         │
└────────────────────┬────────────────────────────────────────┘
                     │ ref.watch()
┌────────────────────▼────────────────────────────────────────┐
│              Database Provider (Future)                     │
│  - Single source of truth                                   │
│  - Initialized once, cached for app lifetime                │
│  - Provides DAOs to repositories                            │
└─────────────────────────────────────────────────────────────┘
```

## Provider Types Used

### 1. FutureProvider
**Purpose**: One-time async data loading, cached result
**Example**: Database initialization, repository creation

```dart
final databaseProvider = FutureProvider<AppDatabase>((ref) async {
  // Initialize and return database instance
  final database = await $FloorAppDatabase.databaseBuilder(...).build();
  return database;
});

final todoRepositoryProvider = FutureProvider<TodoRepository>((ref) async {
  final database = await ref.watch(databaseProvider.future);
  return TodoRepository(database.todoDao);
});
```

**Key Points**:
- ✅ Result is cached - only runs once
- ✅ UI uses `.when()` to handle loading/data/error states
- ✅ Perfect for database/repository initialization

### 2. NotifierProvider
**Purpose**: Mutable state with methods to update it
**Example**: Search query, filters, selections

```dart
class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  
  void setQuery(String query) => state = query;
  void clear() => state = '';
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(
  () => SearchQueryNotifier(),
);
```

**Key Points**:
- ✅ Holds simple state (String, int, bool, enums)
- ✅ Provides methods to update state
- ✅ UI reads state and calls notifier methods
- ✅ Other providers watch and react to changes

### 3. AsyncNotifierProvider
**Purpose**: Async computed state that rebuilds when dependencies change
**Example**: Filtered/searched data from database

```dart
class FilteredTodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // Watch dependencies - rebuilds when any change
    final searchQuery = ref.watch(searchQueryProvider);
    final typeFilter = ref.watch(typeFilterProvider);
    final statusFilter = ref.watch(statusFilterProvider);
    
    // Get repository
    final repository = await ref.watch(todoRepositoryProvider.future);
    
    // Perform filtered query
    return await repository.searchTodos(...);
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}
```

**Key Points**:
- ✅ Automatically rebuilds when watched providers change
- ✅ Returns `AsyncValue<T>` with loading/data/error states
- ✅ Perfect for database queries with multiple filters
- ✅ Can be manually refreshed after mutations

### 4. StateNotifierProvider (Alternative Pattern)
**Purpose**: Complex state with immutable updates
**Example**: List management with CRUD operations

```dart
class TodosNotifier extends StateNotifier<AsyncValue<List<Todo>>> {
  TodosNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadTodos();
  }
  
  final TodoRepository _repository;
  
  Future<void> addTodo(Todo todo) async {
    await _repository.addTodo(todo);
    await _loadTodos(); // Reload after mutation
  }
}
```

**Note**: This project uses `AsyncNotifierProvider` instead for cleaner syntax.

## Feature-Specific Providers

### Todos Feature

```dart
// Database layer
databaseProvider → todoRepositoryProvider
                    ↓
// State providers (UI filters)
searchQueryProvider (NotifierProvider<String>)
typeFilterProvider (NotifierProvider<String?>)
statusFilterProvider (NotifierProvider<TodoStatus>)
                    ↓
// Computed providers (filtered data)
filteredTodosProvider (AsyncNotifierProvider<List<Todo>>)
  - Watches: searchQuery, typeFilter, statusFilter, repository
  - Returns: Database-filtered todos
                    ↓
todoStatsProvider (Provider<TodoStats>)
  - Watches: filteredTodosProvider
  - Returns: Computed stats (total, completed, pending)
                    ↓
// UI
TodoListScreen (ConsumerWidget)
  - Watches: filteredTodosProvider, searchQueryProvider, typeFilterProvider
  - Displays: Filtered todos with loading/error states
```

### Pets Feature

```dart
// Database layer
databaseProvider → petRepositoryProvider
                    ↓
// State providers
selectedOwnerIdProvider (NotifierProvider<int?>)
                    ↓
// Data providers
ownersProvider (FutureProvider<List<Owner>>)
  - Watches: petRepositoryProvider
  - Returns: All owners

petsProvider (FutureProvider<List<Pet>>)
  - Watches: selectedOwnerIdProvider, petRepositoryProvider
  - Returns: Pets filtered by selected owner

petsWithOwnersProvider (FutureProvider<List<PetOwner>>)
  - Watches: petRepositoryProvider
  - Returns: Database view JOIN results
                    ↓
// UI
PetsScreen (ConsumerWidget)
  - Watches: ownersProvider, petsProvider, selectedOwnerIdProvider
  - Displays: Owner list and filtered pet list
```

## Communication Patterns

### Pattern 1: State → Computed → UI
```dart
// State provider
ref.read(searchQueryProvider.notifier).setQuery('flutter');
       ↓
// Triggers rebuild in computed provider
filteredTodosProvider (watches searchQueryProvider)
       ↓
// UI automatically updates
ConsumerWidget (watches filteredTodosProvider)
```

### Pattern 2: Mutation → Manual Refresh
```dart
// Mutation
await repository.addTodo(newTodo);
       ↓
// Manual refresh
ref.read(filteredTodosProvider.notifier).refresh();
       ↓
// Triggers database query
filteredTodosProvider.build() runs again
       ↓
// UI updates
ConsumerWidget sees new AsyncValue
```

### Pattern 3: Invalidation (Cache Clearing)
```dart
// Invalidate specific provider
ref.invalidate(petsProvider);
       ↓
// Provider rebuilds from scratch
petsProvider.build() runs again
       ↓
// UI updates with fresh data
```

## Best Practices

### ✅ DO:
- Use `FutureProvider` for one-time initialization (database, repositories)
- Use `NotifierProvider` for simple mutable state (search, filters)
- Use `AsyncNotifierProvider` for computed data with dependencies
- Watch only what you need - avoid unnecessary rebuilds
- Use `.future` when awaiting FutureProvider in async context
- Call `.notifier` when updating state from UI
- Use `ref.invalidate()` to force provider rebuild
- Handle `AsyncValue` states in UI (.when, .maybeWhen)

### ❌ DON'T:
- Don't use StreamProvider on Windows (sqflite_ffi doesn't support reactive queries)
- Don't watch providers in build() that aren't used for rendering
- Don't mutate state directly - use notifier methods
- Don't forget to refresh/invalidate after database mutations
- Don't create circular dependencies between providers

## Debugging Tips

```dart
// Print when provider rebuilds
@override
Future<List<Todo>> build() async {
  print('filteredTodosProvider rebuilding');
  // ... rest of build
}

// Check provider state
final state = ref.read(filteredTodosProvider);
print(state); // AsyncValue.loading() / AsyncValue.data() / AsyncValue.error()

// Monitor provider changes
ref.listen(searchQueryProvider, (prev, next) {
  print('Search changed: $prev → $next');
});
```

## Summary

The provider architecture creates a **reactive data flow** where:
1. UI updates state providers (search, filters)
2. State changes trigger computed providers to rebuild
3. Computed providers fetch fresh data from repositories
4. UI automatically updates with new AsyncValue states
5. Mutations trigger manual refresh/invalidate cycles

This architecture provides **type-safe**, **reactive**, and **testable** state management with clear separation of concerns.