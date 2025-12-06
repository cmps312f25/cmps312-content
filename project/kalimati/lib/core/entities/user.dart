import 'package:floor/floor.dart';
import 'package:uuid/uuid.dart';

@Entity(tableName: "users")
class User {
  @PrimaryKey()
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String photoUrl;
  final String role;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.photoUrl,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'photoUrl': photoUrl,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? Uuid().v4(),
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
