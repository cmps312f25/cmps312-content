class Pet {
  final int? id; // Primary key
  final String name;
  final int ownerId; // Foreign key linking to the Owner table
  final String? imagePath; // Path to image in Supabase Storage

  Pet({this.id, required this.name, required this.ownerId, this.imagePath});

  // From JSON - for deserializing from Supabase
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as int?,
      name: json['name'] as String,
      ownerId: json['owner_id'] as int,
      imagePath: json['image_path'] as String?,
    );
  }

  // To JSON - for serializing to Supabase
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'owner_id': ownerId,
      if (imagePath != null) 'image_path': imagePath,
    };
  }

  // Copy with method for updating pet data
  Pet copyWith({int? id, String? name, int? ownerId, String? imagePath}) {
    return Pet(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  @override
  String toString() =>
      'Pet(id: $id, name: $name, ownerId: $ownerId, imagePath: $imagePath)';
}
