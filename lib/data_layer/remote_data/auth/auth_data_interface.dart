import 'package:flutter/cupertino.dart';
import 'package:mafrashi/model/user.dart';

abstract class AuthApi {
  Future<User> login(String email, String password);

  Future<bool> logout();

  Future<bool> signUp(
      {@required String firstName,
      @required String lastName,
      @required String email,
      @required String gender,
      @required String password,
      @required String confirmPassword,
      @required String phone,
      @required String dateOfBirth});
}
