import 'package:kalimati/features/auth/repository/auth_repo_contract.dart';
import 'package:kalimati/core/entities/user.dart';
import 'package:kalimati/core/data/daos/user_dao.dart';

class AuthRepoLocalDb implements AuthRepo {
  final UserDao _userDao;

  AuthRepoLocalDb(this._userDao);
  @override
  Future<User?> getUserById(String id) {
    return _userDao.getUserById(id);
  }

  @override
  Stream<List<User>> getUsers() {
    return _userDao.getUsers();
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    final user = await _userDao.getUserByEmailAndPassword(email, password);
    if (user == null) {
      throw Exception('Invalid email or password');
    }
    return user;
  }
}
