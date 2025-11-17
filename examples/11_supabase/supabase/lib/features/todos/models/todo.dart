enum TodoType {
  personal('Personal'),
  work('Work'),
  family('Family');

  final String title;

  const TodoType(this.title);
}

class Todo {
  final int? id; // Auto-assigned by the database
  final String description;
  final bool completed;
  final TodoType type;
  final String? createdBy; // UUID referencing auth.users(id)
  final DateTime createdAt;

  Todo({
    this.id,
    required this.description,
    this.completed = false,
    this.type = TodoType.personal,
    this.createdBy,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // From JSON - for deserializing from Supabase
  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int?,
      description: json['description'] as String,
      completed: json['completed'] as bool,
      type: TodoType.values.firstWhere(
        (e) => e.title == json['type'], // Match by title (capitalized)
        orElse: () => TodoType.personal,
      ),
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  // To JSON - for serializing to Supabase
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id, // Exclude id when null (for inserts)
      'description': description,
      'completed': completed,
      'type': type.title, // Use title (capitalized) for database constraint
      if (createdBy != null) 'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Copy with method for immutable updates. Needed for state management libraries such as Riverpod.
  // The Todo class uses final fields, making instances immutable (cannot be changed after creation)
  // e.g., Mark toDo as completed - Only specify fields you want to change
  // final completedTodo = todo.copyWith(completed: true);
  Todo copyWith({
    int? id,
    String? description,
    bool? completed,
    TodoType? type,
    String? createdBy,
    DateTime? createdAt,
  }) {
    return Todo(
      id: id ?? this.id,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      type: type ?? this.type,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed, type: $type, createdBy: $createdBy, createdAt: $createdAt)';
  }
}
