import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/user.dart';

class FakeUserManager implements UserManager {
  User _user;
  FakeUserManager(this._user);
  @override
  Future<void> deleteUserData() async {
    _user = null;
  }

  @override
  Future<User> getUserData() async {
    return _user;
  }

  @override
  Future<void> saveUserData(User user) async {
    _user = user;
  }
}
