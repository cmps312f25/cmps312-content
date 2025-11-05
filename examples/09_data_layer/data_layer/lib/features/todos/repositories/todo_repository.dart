import 'package:data_layer/features/todos/models/todo.dart';
import 'package:data_layer/features/todos/daos/todo_dao.dart';
import 'package:data_layer/features/todos/providers/status_filter_provider.dart';
import 'package:uuid/uuid.dart';

class TodoRepository {
  static const _uuid = Uuid();
  final TodoDao _todoDao;

  TodoRepository(this._todoDao);

  // CRUD operations using Floor DAO
  Future<List<Todo>> getTodos() => _todoDao.getTodos();

  Stream<List<Todo>> observeTodos() => _todoDao.observeTodos();

  Future<Todo?> getTodoById(String id) => _todoDao.getTodoById(id);

  Future<void> addTodo(Todo todo) => _todoDao.insertTodo(todo);

  Future<void> updateTodo(Todo todo) => _todoDao.updateTodo(todo);

  Future<void> deleteTodo(String id) => _todoDao.deleteTodoById(id);

  Future<void> deleteAllTodos() => _todoDao.deleteAllTodos();

  Future<int> getTodosCount() async {
    return await _todoDao.getTodosCount() ?? 0;
  }

  // Search todos at database level with flexible filtering
  // Pass null/empty for filters you don't want to apply
  // The SQL query handles empty filters using OR conditions
  Future<List<Todo>> searchTodos({
    String? searchQuery,
    String? typeFilter,
    TodoStatus statusFilter = TodoStatus.pending,
  }) {
    // Use empty string ('') for null/empty filters
    // Use -1 for null completion filter (since 0=false, 1=true)
    final query = searchQuery?.trim() ?? '';
    final type = typeFilter?.trim() ?? '';

    
    // Convert completion filter to nullable bool for database query
    final int completedFilter = switch (statusFilter) {
      TodoStatus.all => -1, // No filter
      TodoStatus.pending => 0, // Only incomplete todos
      TodoStatus.completed => 1, // Only completed todos
    };

    return _todoDao.searchTodos(query, type, completedFilter);
  }

  // Initialize with test data if database is empty
  Future<void> initializeWithTestData() async {
    final count = await getTodosCount();
    if (count == 0) {
      final testTodos = [
        Todo(
          id: _uuid.v4(),
          description: 'Learn Navigation',
          type: TodoType.personal,
        ),
        Todo(
          id: _uuid.v4(),
          description: 'Practice state management using Riverpod',
          type: TodoType.work,
        ),
        Todo(
          id: _uuid.v4(),
          description: 'Explore more widgets and layouts',
          type: TodoType.personal,
        ),
        Todo(
          id: _uuid.v4(),
          description: 'Plan family vacation',
          type: TodoType.family,
          completed: true,
        ),
      ];
      await _todoDao.insertTodos(testTodos);
    }
  }
}
