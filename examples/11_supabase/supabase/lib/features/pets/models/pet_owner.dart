class PetOwner {
  final String petName;
  final String ownerName;

  PetOwner({required this.petName, required this.ownerName});

  // From JSON - for deserializing from Supabase
  factory PetOwner.fromJson(Map<String, dynamic> json) {
    return PetOwner(
      petName: json['pet_name'] as String,
      ownerName: json['owner_name'] as String,
    );
  }

  // To JSON - for serializing to Supabase
  Map<String, dynamic> toJson() {
    return {'pet_name': petName, 'owner_name': ownerName};
  }
}
