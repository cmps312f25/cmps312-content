import 'package:data_layer/features/todos/models/todo.dart';
import 'package:data_layer/features/todos/database/todo_dao.dart';

class TodoRepository {
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
  // Uses different queries based on whether type filter is applied
  Future<List<Todo>> searchTodos({
    String searchQuery = '',
    String? typeFilter,
  }) {
    // Choose appropriate query based on filter presence
    if (typeFilter != null && typeFilter.isNotEmpty) {
      return _todoDao.searchTodosByDescriptionAndType(searchQuery, typeFilter);
    } else {
      return _todoDao.searchTodosByDescription(searchQuery);
    }
  }

  // Initialize with test data if database is empty
  Future<void> initializeWithTestData() async {
    final count = await getTodoCount();
    if (count == 0) {
      final testTodos = [
        Todo(
          id: 'todo-1',
          description: 'Learn Navigation',
          type: TodoType.personal,
        ),
        Todo(
          id: 'todo-2',
          description: 'Practice state management using Riverpod',
          type: TodoType.work,
        ),
        Todo(
          id: 'todo-3',
          description: 'Explore more widgets and layouts',
          type: TodoType.personal,
        ),
        Todo(
          id: 'todo-4',
          description: 'Plan family vacation',
          type: TodoType.family,
          completed: true,
        ),
      ];
      await _todoDao.insertTodos(testTodos);
    }
  }
}
