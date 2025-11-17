import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_app/features/todos/models/todo.dart';
import 'package:supabase_app/features/todos/providers/status_filter_provider.dart';

class TodoRepository {
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

  Future<Todo?> getTodoById(int id) async {
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
    await _client.from('todos').update(todo.toJson()).eq('id', todo.id!);
  }

  Future<void> deleteTodo(int id) async {
    await _client.from('todos').delete().eq('id', id);
  }

  Future<void> deleteAllTodos() async {
    await _client.from('todos').delete().neq('id', 0);
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
}
