import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';

class FakeUserManager implements UserManager {
  String email;
  String token;
  String password;
  FakeUserManager({this.email, this.token, this.password});

  @override
  Future<String> getToken() async {
    // TODO: implement getToken
    return token;
  }

  @override
  Future<String> getUserEmail() async {
    // TODO: implement getUserEmail
    return email;
  }

  @override
  Future<void> saveToken(String token) async {
    token = await token;
  }

  @override
  Future<void> saveUserData(String email, String password) async {
    email = email;
    password = password;
  }

  @override
  Future<void> deleteUserData() async {
    email = null;
    token = null;
  }

  @override
  Future<String> getUserPassword() async {
    // TODO: implement getUserPassword
    return password;
  }
}
