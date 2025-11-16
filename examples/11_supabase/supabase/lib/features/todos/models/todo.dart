enum TodoType {
  personal('Personal'),
  work('Work'),
  family('Family');

  final String title;

  const TodoType(this.title);
}

class Todo {
  final String id;
  final String description;
  final bool completed;
  final TodoType type;
  final DateTime createdAt;

  Todo({
    required this.id,
    required this.description,
    this.completed = false,
    this.type = TodoType.personal,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // From JSON - for deserializing from Supabase
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as String,
      description: json['description'] as String,
      completed: json['completed'] as bool,
      type: TodoType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TodoType.personal,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // To JSON - for serializing to Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'completed': completed,
      'type': type.name,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Copy with method for immutable updates. Needed for state management libraries such as Riverpod.
  // The Todo class uses final fields, making instances immutable (cannot be changed after creation)
  // e.g., Mark toDo as completed - Only specify fields you want to change
  // final completedTodo = todo.copyWith(completed: true);
  Todo copyWith({
    String? id,
    String? description,
    bool? completed,
    TodoType? type,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed, type: $type, createdAt: $createdAt)';
  }
}
