/*
* This class responsible for dealing with user data throw the application
* */
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

const USER = 'user';
const EMAIL = 'email';
const TOKEN = 'token';
const PASSWORD = 'password';

class UserManagerImp implements UserManager {
  String _token;
  String _email;
  String _password;

  @override
  Future<void> saveUserData(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(EMAIL, email);
    sharedPreferences.setString(PASSWORD, password);
  }

  @override
  Future<void> deleteUserData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

  @override
  Future<String> getUserEmail() async {
    if (_email == null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      _email = sharedPreferences.getString(EMAIL);
    }
    return _email;
  }

  @override
  Future<void> saveToken(String token) async {
    _token = token;
  }

  @override
  Future<String> getToken() async {
    return _token;
  }

  @override
  Future<String> getUserPassword() async {
    if (_password == null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      _password = sharedPreferences.getString(PASSWORD);
    }
    return _password;
  }
}
