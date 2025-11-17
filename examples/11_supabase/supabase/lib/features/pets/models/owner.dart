class Owner {
  final int? id;
  final String firstName;
  final String lastName;

  Owner({this.id, required this.firstName, required this.lastName});

  // Computed property for full name
  String get fullName => '$firstName $lastName';

  // From JSON - for deserializing from Supabase
  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] as int?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
    );
  }

  // To JSON - for serializing to Supabase
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'first_name': firstName,
      'last_name': lastName,
    };
  }

  @override
  String toString() =>
      'Owner(id: $id, firstName: $firstName, lastName: $lastName)';
}
