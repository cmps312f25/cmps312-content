import 'package:floor/floor.dart';
import 'package:data_layer/features/todos/models/todo.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM todo ORDER BY createdAt DESC')
  Future<List<Todo>> getAllTodos();

  @Query('SELECT * FROM todo ORDER BY createdAt DESC')
  Stream<List<Todo>> watchAllTodos();

  @Query('SELECT * FROM todo WHERE id = :id')
  Future<Todo?> getTodoById(String id);

  @insert
  Future<void> insertTodo(Todo todo);

  @insert
  Future<void> insertTodos(List<Todo> todos);

  @update
  Future<void> updateTodo(Todo todo);

  @delete
  Future<void> deleteTodo(Todo todo);

  @Query('DELETE FROM todo WHERE id = :id')
  Future<void> deleteTodoById(String id);

  @Query('DELETE FROM todo')
  Future<void> deleteAllTodos();

  @Query('SELECT COUNT(*) FROM todo')
  Future<int?> getTodoCount();

  // Search todos by description only - simple LIKE query
  // Uses SQL LIKE with % wildcards for case-insensitive partial matches
  @Query('''
    SELECT * FROM todo 
    WHERE description LIKE '%' || :searchQuery || '%'
    ORDER BY createdAt DESC
  ''')
  Future<List<Todo>> searchTodosByDescription(String searchQuery);

  // Search todos by type only - exact match
  @Query('''
    SELECT * FROM todo 
    WHERE type = :typeFilter
    ORDER BY createdAt DESC
  ''')
  Future<List<Todo>> searchTodosByType(String typeFilter);

  // Search todos by description and type - combined filters
  @Query('''
    SELECT * FROM todo 
    WHERE description LIKE '%' || :searchQuery || '%'
    AND type = :typeFilter
    ORDER BY createdAt DESC
  ''')
  Future<List<Todo>> searchTodosByDescriptionAndType(
    String searchQuery,
    String typeFilter,
  );
}
