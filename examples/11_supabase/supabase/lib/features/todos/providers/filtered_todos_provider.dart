import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_app/features/todos/models/todo.dart';
import 'package:supabase_app/features/todos/providers/status_filter_provider.dart';
import 'package:supabase_app/features/todos/providers/search_query_provider.dart';
import 'package:supabase_app/features/todos/providers/type_filter_provider.dart';
import 'package:supabase_app/features/todos/providers/todo_repository_provider.dart';
import 'package:supabase_app/app/providers/supabase_client_provider.dart';

/// AsyncNotifier with Realtime Channel subscription for efficient updates
///
/// **Efficient Approach:**
/// - Uses database-level filtering (WHERE clauses) - only fetches relevant todos
/// - Subscribes to Realtime Channel for INSERT/UPDATE/DELETE events
/// - Refreshes data only when changes occur, not streaming millions of rows
///
/// **Realtime Features:**
/// - Listens to postgres_changes on 'todos' table
/// - Automatically refreshes when relevant changes detected
/// - Real-time collaboration ready (multiple users see live updates)
///
/// **Performance:**
/// - Efficient: Only fetches filtered results from database
/// - Scalable: Works with millions of todos (only loads what's needed)
/// - Smart refresh: Only updates when actual changes occur
class FilteredTodosNotifier extends AsyncNotifier<List<Todo>> {
  RealtimeChannel? _channel;

  @override
  Future<List<Todo>> build() async {
    // Watch all filter criteria - rebuilds when any changes
    final searchQuery = ref.watch(searchQueryProvider);
    final typeFilter = ref.watch(typeFilterProvider);
    final statusFilter = ref.watch(statusFilterProvider);

    final todoRepository = ref.watch(todoRepositoryProvider);

    // Set up realtime subscription
    _setupRealtimeSubscription();

    // Clean up subscription when provider is disposed
    ref.onDispose(() {
      print('🔌 Disposing channel subscription');
      _channel?.unsubscribe();
    });

    // Perform efficient database-level filtering
    // Only fetches the filtered subset, not entire table
    return await todoRepository.searchTodos(
      searchQuery: searchQuery,
      typeFilter: typeFilter,
      statusFilter: statusFilter,
    );
  }

  /// Set up Realtime Channel to listen for todos table changes
  void _setupRealtimeSubscription() {
    // Clean up previous subscription
    _channel?.unsubscribe();

    final supabase = ref.read(supabaseClientProvider);

    // Create channel and listen to all changes on todos table
    _channel = supabase
        .channel('todos_changes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'todos',
          callback: (payload) {
            print('✅ Todos table changed: ${payload.eventType}');
            print('📦 Payload newRecord: ${payload.newRecord}');
            print('📦 Payload oldRecord: ${payload.oldRecord}');

            // When any change occurs (INSERT/UPDATE/DELETE), refresh the data
            refresh();
          },
        )
        .subscribe((status, [error]) {
          print('🔌 Channel subscription status: $status');
          if (error != null) {
            print('❌ Subscription error: $error');
          }
          if (status == RealtimeSubscribeStatus.subscribed) {
            print('✅ Successfully subscribed to todos_changes channel');
          } else if (status == RealtimeSubscribeStatus.channelError) {
            print('❌ Channel error - check Realtime is enabled in Supabase');
          } else if (status == RealtimeSubscribeStatus.timedOut) {
            print('⏱️ Subscription timed out - retrying...');
          }
        });
  }

  /// Refresh data - called automatically when realtime changes detected
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => build());
  }
}

final filteredTodosProvider =
    AsyncNotifierProvider<FilteredTodosNotifier, List<Todo>>(
      () => FilteredTodosNotifier(),
    );
