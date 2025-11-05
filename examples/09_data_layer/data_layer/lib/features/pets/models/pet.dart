import 'package:floor/floor.dart';
import 'package:data_layer/features/pets/models/owner.dart';

@Entity(
  foreignKeys: [
    ForeignKey(
      childColumns: ['ownerId'], // Column in this entity
      parentColumns: ['id'], // Column in the parent entity
      entity: Owner,
      onDelete: ForeignKeyAction.cascade,
    ),
  ],
  indices: [
    Index(value: ['ownerId']),
  ],
)
class Pet {
  @PrimaryKey(autoGenerate: true)
  final int? id; // Primary key
  final String name;
  final int ownerId; // Foreign key linking to the Owner table

  Pet({this.id, required this.name, required this.ownerId});

  @override
  String toString() => 'Pet(id: $id, name: $name, ownerId: $ownerId)';
}
