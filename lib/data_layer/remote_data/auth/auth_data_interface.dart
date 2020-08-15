import 'package:flutter/cupertino.dart';

abstract class AuthApi {
  Future<String> login(String email, String password);

  Future<bool> logout(String email);

  Future<bool> signUp(
      {@required String firstName,
      @required String lastName,
      @required String email,
      @required String gender,
      @required String password,
      @required String confirmPassword,
      @required String phone,
      @required String dateOfBirth});

  Future<String> forgetPassword(String email);
}
