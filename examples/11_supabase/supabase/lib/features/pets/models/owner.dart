class Owner {
  final int? id;
  final String name;

  Owner({this.id, required this.name});

  // From JSON - for deserializing from Supabase
  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(id: json['id'] as int?, name: json['name'] as String);
  }

  // To JSON - for serializing to Supabase
  Map<String, dynamic> toJson() {
    return {if (id != null) 'id': id, 'name': name};
  }

  @override
  String toString() => 'Owner(id: $id, name: $name)';
}
