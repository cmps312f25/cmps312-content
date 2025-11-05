import 'package:floor/floor.dart';

@entity
class Owner {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String name;

  Owner({this.id, required this.name});

  @override
  String toString() => 'Owner(id: $id, name: $name)';
}
