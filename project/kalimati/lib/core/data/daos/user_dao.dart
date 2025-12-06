import 'package:floor/floor.dart';
import 'package:kalimati/core/entities/user.dart';

@dao
abstract class UserDao {
  @Query("SELECT * FROM users")
  Stream<List<User>> getUsers();

  @Query("SELECT * FROM users WHERE email =:id")
  Future<User?> getUserById(String id);

  @Query("SELECT * FROM users WHERE email = :email AND password = :password")
  Future<User?> getUserByEmailAndPassword(String email, String password);

  @Query("DELETE FROM users")
  Future<void> clearUsers();

  @insert
  Future<void> insertUsers(List<User> users);
}
