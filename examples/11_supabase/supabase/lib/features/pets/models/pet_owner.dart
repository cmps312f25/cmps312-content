class PetOwner {
  final String petName;
  final String ownerFirstName;
  final String ownerLastName;
  final String? petImagePath;

  PetOwner({
    required this.petName,
    required this.ownerFirstName,
    required this.ownerLastName,
    this.petImagePath,
  });

  // Computed property for full owner name
  String get ownerFullName => '$ownerFirstName $ownerLastName';

  // From JSON - for deserializing from Supabase
  factory PetOwner.fromJson(Map<String, dynamic> json) {
    return PetOwner(
      petName: json['pet_name'] as String,
      ownerFirstName: json['owner_first_name'] as String,
      ownerLastName: json['owner_last_name'] as String,
      petImagePath: json['pet_image_path'] as String?,
    );
  }

  // To JSON - for serializing to Supabase
  Map<String, dynamic> toJson() {
    return {
      'pet_name': petName,
      'owner_first_name': ownerFirstName,
      'owner_last_name': ownerLastName,
      if (petImagePath != null) 'pet_image_path': petImagePath,
    };
  }
}
