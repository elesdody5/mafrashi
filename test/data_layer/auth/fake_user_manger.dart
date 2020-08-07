import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';

class FakeUserManager implements UserManager {
  String _email;
  String _token;
  String _password;
  FakeUserManager(this._email, this._token);

  @override
  Future<String> getToken() async {
    // TODO: implement getToken
    return _token;
  }

  @override
  Future<String> getUserEmail() async {
    // TODO: implement getUserEmail
    return _token;
  }

  @override
  Future<void> saveToken(String token) async {
    _token = await token;
  }

  @override
  Future<void> saveUserData(String email, String password) async {
    _email = email;
    _password = password;
  }

  @override
  Future<void> deleteUserData() async {
    _email = null;
    _token = null;
  }

  @override
  Future<String> getUserPassword() async {
    // TODO: implement getUserPassword
    return _password;
  }
}
