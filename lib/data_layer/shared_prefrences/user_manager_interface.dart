import 'package:mafrashi/model/user.dart';

abstract class UserManager {
  Future<void> saveUserData(User user);
  Future<void> deleteUserData();
  Future<User> getUserData();
}
