class Pet {
  final int? id; // Primary key
  final String name;
  final int ownerId; // Foreign key linking to the Owner table

  Pet({this.id, required this.name, required this.ownerId});

  // From JSON - for deserializing from Supabase
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as int?,
      name: json['name'] as String,
      ownerId: json['owner_id'] as int,
    );
  }

  // To JSON - for serializing to Supabase
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'name': name, 'owner_id': ownerId};
  }

  @override
  String toString() => 'Pet(id: $id, name: $name, ownerId: $ownerId)';
}
