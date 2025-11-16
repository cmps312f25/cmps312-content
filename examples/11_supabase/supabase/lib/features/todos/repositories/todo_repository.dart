import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_app/features/todos/models/todo.dart';
import 'package:supabase_app/features/todos/providers/status_filter_provider.dart';
import 'package:uuid/uuid.dart';

class TodoRepository {
  static const _uuid = Uuid();
  final SupabaseClient _client;

  TodoRepository(this._client);

  // ==================== CRUD Operations ====================

  Future<List<Todo>> getTodos() async {
    final response = await _client
        .from('todos')
        .select()
        .order('created_at', ascending: false);
    return (response as List).map((json) => Todo.fromJson(json)).toList();
  }

  Stream<List<Todo>> observeTodos() {
    return _client
        .from('todos')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Todo.fromJson(json)).toList());
  }

  Future<Todo?> getTodoById(String id) async {
    final response = await _client
        .from('todos')
        .select()
        .eq('id', id)
        .maybeSingle();
    return response != null ? Todo.fromJson(response) : null;
  }

  Future<void> addTodo(Todo todo) async {
    await _client.from('todos').insert(todo.toJson());
  }

  Future<void> updateTodo(Todo todo) async {
    await _client.from('todos').update(todo.toJson()).eq('id', todo.id);
  }

  Future<void> deleteTodo(String id) async {
    await _client.from('todos').delete().eq('id', id);
  }

  Future<void> deleteAllTodos() async {
    await _client.from('todos').delete().neq('id', '');
  }

  Future<int> getTodosCount() async {
    final response = await _client
        .from('todos')
        .select()
        .count(CountOption.exact);
    return response.count;
  }

  // ==================== Search & Filter Operations ====================

  /// Search todos at database level with flexible filtering
  /// Pass null/empty for filters you don't want to apply
  Future<List<Todo>> searchTodos({
    String? searchQuery,
    String? typeFilter,
    TodoStatus statusFilter = TodoStatus.pending,
  }) async {
    var query = _client.from('todos').select();

    // Apply search query filter if not empty
    final trimmedQuery = searchQuery?.trim() ?? '';
    if (trimmedQuery.isNotEmpty) {
      query = query.ilike('description', '%$trimmedQuery%');
    }

    // Apply type filter if not empty
    final trimmedType = typeFilter?.trim() ?? '';
    if (trimmedType.isNotEmpty) {
      query = query.eq('type', trimmedType);
    }

    // Apply completion filter based on status
    switch (statusFilter) {
      case TodoStatus.pending:
        query = query.eq('completed', false);
        break;
      case TodoStatus.completed:
        query = query.eq('completed', true);
        break;
      case TodoStatus.all:
        // No filter
        break;
    }

    final response = await query.order('created_at', ascending: false);
    return (response as List).map((json) => Todo.fromJson(json)).toList();
  }

  // ==================== Initialization ====================

  /// Initialize with test data if database is empty
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

      // Insert all todos
      await _client
          .from('todos')
          .insert(testTodos.map((t) => t.toJson()).toList());
    }
  }
}
