import 'package:rime/data/models/User.dart';
import 'package:rime/data/repositories/UserRepository.dart';
import 'package:rime/data/services/ActivityService.dart';
import 'package:rime/presentation/utils/activity_description.dart';
import 'package:rime/presentation/utils/errors.dart';
import 'package:rime/presentation/utils/funcs.dart';

class AuthService {
  UserRepository userRepository = UserRepository();
  ActivityService activityService = ActivityService();
  Future<User?> login(String username, String password) async {
    try {
      User? user = await userRepository.findUserByUsernameAndPassword(
          username, password);
      final success =
          activityService.createActivity(description: LOGIN, userId: user!.id);
      return user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User?> register(String username, String password) async {
    try {
      bool _userExists = await userRepository.userExists(username);
      print(_userExists);
      if (_userExists == true) {
        throw UserAlreadyExistsException("user exists already");
      }
      final user = await userRepository.createUser(username, password);
      return user;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> checkPassword(int userId, String password) async {
    try {
      String? hashedPassword =
          await this.userRepository.getUserPassword(userId);
      if (hashedPassword == null) return false;
      if (hashPasswordWithMd5(password) == hashedPassword) return true;
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
