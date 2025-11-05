import 'package:floor/floor.dart';
import 'package:data_layer/features/todos/models/todo.dart';

@dao
abstract class TodoDao {
  @Query('SELECT * FROM todo ORDER BY createdAt DESC')
  Future<List<Todo>> getTodos();

  @Query('SELECT * FROM todo ORDER BY createdAt DESC')
  Stream<List<Todo>> observeTodos();

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
  Future<int?> getTodosCount();

  // Flexible search query that handles empty/null filters using OR conditions
  // Empty string ('') means skip this filter
  // -1 means skip completion filter (since completed is 0 or 1)
  @Query('''
    SELECT * FROM todo 
    WHERE (:searchQuery = '' OR description LIKE '%' || :searchQuery || '%')
    AND (:typeFilter = '' OR type = :typeFilter)
    AND (:completedFilter = -1 OR completed = :completedFilter)
    ORDER BY createdAt DESC
  ''')
  Future<List<Todo>> searchTodos(
    String searchQuery,
    String typeFilter,
    int completedFilter,
  );
}
