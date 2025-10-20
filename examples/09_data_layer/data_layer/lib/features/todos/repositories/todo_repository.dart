import 'package:data_layer/features/todos/models/todo.dart';
import 'package:data_layer/features/todos/database/todo_dao.dart';
import 'package:uuid/uuid.dart';

class TodoRepository {
  static const _uuid = Uuid();
  final TodoDao _todoDao;

  TodoRepository(this._todoDao);

  // CRUD operations using Floor DAO
  Future<List<Todo>> getAllTodos() => _todoDao.getAllTodos();

  Stream<List<Todo>> watchAllTodos() => _todoDao.watchAllTodos();

  Future<Todo?> getTodoById(String id) => _todoDao.getTodoById(id);

  Future<void> addTodo(Todo todo) => _todoDao.insertTodo(todo);

  Future<void> updateTodo(Todo todo) => _todoDao.updateTodo(todo);

  Future<void> deleteTodo(String id) => _todoDao.deleteTodoById(id);

  Future<void> deleteAllTodos() => _todoDao.deleteAllTodos();

  Future<int> getTodoCount() async {
    return await _todoDao.getTodoCount() ?? 0;
  }

  // Search todos at database level - delegates to appropriate DAO method
  Future<List<Todo>> searchTodos({
    String searchQuery = '',
    String? typeFilter,
  }) {
    final query = searchQuery.trim();
    final type = typeFilter?.trim();

    final hasQuery = query.isNotEmpty;
    final hasType = type != null && type.isNotEmpty;

    // Both filters active
    if (hasQuery && hasType) {
      return _todoDao.searchTodosByDescriptionAndType(query, type);
    }

    // Type filter only
    if (hasType) {
      return _todoDao.searchTodosByType(type);
    }

    // Search query only
    if (hasQuery) {
      return _todoDao.searchTodosByDescription(query);
    }

    // No filters - return all
    return getAllTodos();
  }

  // Initialize with test data if database is empty
  Future<void> initializeWithTestData() async {
    final count = await getTodoCount();
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
