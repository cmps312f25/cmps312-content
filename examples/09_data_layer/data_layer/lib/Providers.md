# Riverpod Provider Architecture

## Overview
This project uses **Riverpod** for state management with a layered architecture: Database → Repository → Providers → UI. Providers communicate through dependency watching (`ref.watch`) creating a reactive data flow.

## Provider Communication Flow

### Architecture Layers - Two Reactive Data Flow Paths

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                            UI Layer (ConsumerWidget)                                │
└────────────┬────────────────────────────────────────────────────────┬────────────────┘
             │                                                        │
    ◄────────┴────────►                                      ◄────────┴────────►
   REACTIVE SEARCH/FILTER                                   MUTATION WITH MANUAL
    (Automatic Rebuild)                                      REFRESH (Explicit)
             │                                                        │
             │ User types in search                                  │ User deletes todo
             │ ref.read().notifier.setQuery()                        │ ref.read().notifier.delete()
             ↓                                                        ↓
┌────────────────────────────────┐                    ┌────────────────────────────────┐
│   State Notifier Updates       │                    │   Mutation Provider            │
│   (NotifierProvider)           │                    │   (AsyncNotifierProvider)      │
│                                │                    │                                │
│ • searchQueryProvider          │                    │ • todoListProvider             │
│ • typeFilterProvider           │                    │ • ownersProvider               │
│ • statusFilterProvider         │                    │ • petsProvider                 │
│ • selectedOwnerIdProvider      │                    │                                │
│                                │                    │ Performs DB mutation           │
│ state = "new value"            │                    │ (INSERT/UPDATE/DELETE)         │
└────────────┬───────────────────┘                    └────────────┬───────────────────┘
             │                                                     │
             │ ref.watch() detects change                          │ Mutation complete
             │ AUTOMATIC TRIGGER                                   │ Database updated
             ↓                                                     │
┌────────────────────────────────┐                                │
│   Computed Provider Rebuilds   │                                │ Manual refresh needed
│   (AsyncNotifierProvider)      │                                │ ref.read().notifier.refresh()
│                                │                                │ or ref.invalidate()
│ • filteredTodosProvider        │ ◄──────────────────────────────┤
│                                │                                │
│ @override                      │                                │
│ Future<List<Todo>> build() {   │                                │
│   // Watches state providers   │                                │
│   final query = ref.watch(...) │                                │
│   final filter = ref.watch(...)│                                │
│                                │                                │
│   // Fetches from repository   │                                │
│   return repository.search()   │                                │
│ }                              │                                │
└────────────┬───────────────────┘                                │
             │                                                     │
             │ ref.watch() to get repository                       │
             ↓                                                     │
┌────────────────────────────────┐                                │
│   Repository Provider          │                                │
│   (FutureProvider)             │                                │
│                                │                                │
│ • todoRepositoryProvider       │ ◄──────────────────────────────┘
│ • petRepositoryProvider        │    Also needs repository
│                                │    for mutation operations
│ Provides business logic        │
│ & DAO abstraction              │
└────────────┬───────────────────┘
             │
             │ ref.watch() to get database
             ↓
┌────────────────────────────────┐
│   Database Provider            │
│   (FutureProvider - Singleton) │
│                                │
│ • databaseProvider             │
│                                │
│ Single source of truth         │
│ Initialized once, cached       │
└────────────┬───────────────────┘
             │
             ↓
       ┌──────────┐
       │ SQLite DB │
       └──────────┘
```

### Path Comparison

| Aspect | Left Path (Search/Filter) | Right Path (Mutation) |
|--------|---------------------------|------------------------|
| **Trigger** | User input → State change | User action → DB mutation |
| **Method** | `ref.read().notifier.setQuery()` | `ref.read().notifier.delete()` |
| **Propagation** | ✅ Automatic via `ref.watch()` | ❌ Manual via `.refresh()` |
| **Rebuild** | Computed provider rebuilds automatically | Requires explicit refresh call |
| **Example** | Type "flutter" → filtered list updates | Delete todo → call `.refresh()` to update list |
| **Code Pattern** | `ref.watch(filterProvider)` detects change | `await mutation(); ref.read().notifier.refresh()` |

### Reactive Data Flow Cycle

#### 1️⃣ User Interaction → State Update
```dart
// UI Layer: User types in search bar
SearchBar(
  onChanged: (value) => 
    ref.read(searchQueryProvider.notifier).setQuery(value),
    //    └─ ref.read() gets the notifier
    //       └─ .notifier accesses the class methods
    //          └─ .setQuery() updates internal state
)
```

**Flow:**
```
User Input → ref.read(provider.notifier).method() → State Updated
```

#### 2️⃣ State Change → Automatic Rebuild
```dart
class FilteredTodosNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    // 👀 Watching state - rebuilds when searchQueryProvider changes
    final searchQuery = ref.watch(searchQueryProvider);
    final typeFilter = ref.watch(typeFilterProvider);
    final statusFilter = ref.watch(statusFilterProvider);
    
    // Get repository
    final repository = await ref.watch(todoRepositoryProvider.future);
    
    // Query database with current filters
    return await repository.searchTodos(
      searchQuery: searchQuery,
      typeFilter: typeFilter,
      statusFilter: statusFilter,
    );
  }
}
```

**Flow:**
```
searchQueryProvider state changes
        ↓
ref.watch() detects change
        ↓
filteredTodosProvider.build() called automatically
        ↓
New database query executed
        ↓
AsyncValue<List<Todo>> updated
```

#### 3️⃣ Computed Provider → Repository → Database
```dart
// Computed provider watches repository provider
final repository = await ref.watch(todoRepositoryProvider.future);

// Repository provider watches database provider
final database = await ref.watch(databaseProvider.future);

// Repository exposes DAO methods
return TodoRepository(database.todoDao);
```

**Flow:**
```
filteredTodosProvider
        ↓ ref.watch()
todoRepositoryProvider
        ↓ ref.watch()
databaseProvider
        ↓ provides
TodoDAO → SQL Query → SQLite Database
```

#### 4️⃣ Data Update → UI Rebuild
```dart
// UI watches computed provider
Widget build(BuildContext context, WidgetRef ref) {
  final todosAsync = ref.watch(filteredTodosProvider);
  //                      └─ ref.watch() listens for changes
  
  return todosAsync.when(
    loading: () => CircularProgressIndicator(),
    error: (e, st) => Text('Error: $e'),
    data: (todos) => ListView.builder(
      itemCount: todos.length,
      itemBuilder: (_, i) => TodoTile(todos[i]),
    ),
  );
}
```

**Flow:**
```
filteredTodosProvider state changes
        ↓
Widget rebuilds automatically (ref.watch detected change)
        ↓
.when() handles AsyncValue states
        ↓
UI displays new data
```

#### 5️⃣ Mutation → Manual Refresh Cycle
```dart
// User action: Delete todo
onPressed: () async {
  // Step 1: Perform mutation via notifier
  await ref.read(todoListProvider.notifier).delete(todoId);
  //        └─ ref.read() for one-time action (no listening)
  
  // Step 2: Manually trigger refresh of filtered data
  ref.read(filteredTodosProvider.notifier).refresh();
  //  └─ Calls build() again to fetch fresh data
}
```

**Flow:**
```
User Action (Delete)
        ↓
ref.read().notifier.delete()
        ↓
Database mutation (DELETE query)
        ↓
ref.read().notifier.refresh()
        ↓
filteredTodosProvider.build() called
        ↓
New query fetches updated data
        ↓
UI automatically updates via ref.watch()
```

### Complete Example: Todo Search Flow

```
┌─────────────────────────────────────────────────────────────┐
│ 1. User types "flutter" in SearchBar                        │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│ 2. ref.read(searchQueryProvider.notifier).setQuery("flutter") │
│    - SearchQueryNotifier.state = "flutter"                  │
└──────────────────┬──────────────────────────────────────────┘
                   │ State changed!
┌──────────────────▼──────────────────────────────────────────┐
│ 3. filteredTodosProvider.build() triggered automatically    │
│    - ref.watch(searchQueryProvider) detects change          │
│    - Reads new value: "flutter"                             │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│ 4. Get repository: ref.watch(todoRepositoryProvider.future) │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│ 5. Execute query: repository.searchTodos(                   │
│      searchQuery: "flutter",                                │
│      typeFilter: null,                                      │
│      statusFilter: TodoStatus.all                           │
│    )                                                        │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│ 6. SQL Query: SELECT * FROM todo                            │
│    WHERE description LIKE '%flutter%'                       │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│ 7. Return List<Todo> with matching results                  │
│    - state = AsyncValue.data([todo1, todo2, ...])           │
└──────────────────┬──────────────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│ 8. UI rebuilds automatically                                │
│    - ref.watch(filteredTodosProvider) detected change       │
│    - ListView displays filtered todos                       │
└─────────────────────────────────────────────────────────────┘
```

### Key Differences: ref.watch vs ref.read

| Aspect | `ref.watch()` | `ref.read()` |
|--------|---------------|--------------|
| **Purpose** | Listen to changes | One-time access |
| **Rebuilds** | ✅ Triggers rebuild | ❌ No rebuild |
| **Use in** | `build()` methods | Event handlers, callbacks |
| **Example** | `final todos = ref.watch(todosProvider)` | `ref.read(provider.notifier).add()` |

**Rule of Thumb:**
- Use `ref.watch()` when you want to **display** data or **react** to changes
- Use `ref.read()` when you want to **perform actions** (mutations, one-time operations)

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