# Todo Feature with SQLite Database

## Overview
This todo feature uses Floor (SQLite) for local data persistence with Riverpod for state management.

## Architecture

### Database Layer
- **`database/app_database.dart`** - Floor database configuration
- **`database/todo_dao.dart`** - Data Access Object with CRUD operations
- **`models/todo.dart`** - Todo entity with Floor annotations

### Repository Layer
- **`repositories/todo_repository.dart`** - Abstracts database operations
  - `getAllTodos()` - Fetch all todos
  - `addTodo()` - Add new todo
  - `updateTodo()` - Update existing todo
  - `deleteTodo()` - Delete todo by id
  - `initializeWithTestData()` - Seeds database with test data if empty

### State Management
- **`providers/database_provider.dart`** - Initializes Floor database
- **`providers/todo_list_provider.dart`** - AsyncNotifierProvider for todo CRUD operations
- **`providers/filtered_todos_provider.dart`** - Computed provider for filtered todos
- **`providers/todo_filter_provider.dart`** - Filter state (all/pending/completed)
- **`providers/todo_stats_provider.dart`** - Computed statistics providers

### UI Layer
- **`screens/todo_screen.dart`** - Main todo list screen
- **`widgets/todo_tile.dart`** - Individual todo item with type badge and timestamp
- **`widgets/add_todo_field.dart`** - Input field for new todos
- **`widgets/todo_toolbar.dart`** - Filter toolbar

## Key Features

### Todo Model
- **id**: Unique identifier (UUID)
- **description**: Todo text
- **completed**: Boolean status
- **type**: TodoType enum (personal/work/family)
- **createdAt**: Unix timestamp (milliseconds)

### Database
- Uses **Floor** package for type-safe SQLite operations
- Automatic database initialization with test data
- Type converter for TodoType enum
- Stores DateTime as Unix timestamp for SQLite compatibility

### State Management Pattern
- **AsyncNotifierProvider** for async operations
- Optimistic UI updates (update state immediately, persist to database)
- Simple and maintainable approach
- Automatic loading/error states with AsyncValue

## Usage Example

```dart
// Add a new todo
await ref.read(todoListProvider.notifier).add('Buy groceries', type: TodoType.personal);

// Toggle completion
await ref.read(todoListProvider.notifier).toggle(todoId);

// Remove a todo
await ref.read(todoListProvider.notifier).remove(todoId);

// Watch todos in UI
final todosAsync = ref.watch(todoListProvider);
todosAsync.when(
  data: (todos) => ListView(...),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error),
);
```

## Code Generation

After modifying database entities, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Database Location
- **Development**: `app_database.db` in app documents directory
- Persists across app restarts
- Can be inspected with SQLite tools
