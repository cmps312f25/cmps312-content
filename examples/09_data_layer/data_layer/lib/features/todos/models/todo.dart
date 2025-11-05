import 'package:floor/floor.dart';

enum TodoType {
  personal('Personal'),
  work('Work'),
  family('Family');

  final String title;

  const TodoType(this.title);
}

@Entity(tableName: 'todo')
class Todo {
  @PrimaryKey() // autoGenerate: true
  final String id;

  final String description;
  final bool completed;

  @TypeConverters([TodoTypeConverter])
  final TodoType type;

  @ColumnInfo(name: 'createdAt')
  final int createdAtTimestamp;

  // Expose as DateTime
  DateTime get createdAt =>
      DateTime.fromMillisecondsSinceEpoch(createdAtTimestamp);

  Todo({
    required this.id,
    required this.description,
    this.completed = false,
    this.type = TodoType.personal,
    DateTime? createdAt,
  }) : createdAtTimestamp =
           createdAt?.millisecondsSinceEpoch ??
           DateTime.now().millisecondsSinceEpoch;

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

// Type converter for TodoType enum
class TodoTypeConverter extends TypeConverter<TodoType, String> {
  @override
  TodoType decode(String databaseValue) {
    return TodoType.values.firstWhere((e) => e.name == databaseValue);
  }

  @override
  String encode(TodoType value) {
    return value.name;
  }
}
