import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';

class Auth with ChangeNotifier {
  bool _isAuthenticated = false;
  AuthRepository _authRepository;

  Auth(this._authRepository);

  get isAuthenticated => _isAuthenticated;

  Future<bool> signUp(
      String firstName,
      String lastName,
      String email,
      String gender,
      String password,
      String confirmPassword,
      String phone,
      String dateOfBirth) async {
    return await _authRepository.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
        password: password,
        confirmPassword: confirmPassword,
        phone: phone,
        dateOfBirth: dateOfBirth);
  }

  Future<bool> login(String email, String password) async {
    var result = await _authRepository.login(email, password);
    _isAuthenticated = true;
    return result;
  }

  Future<bool> tryAutoLogin() async {
    _isAuthenticated = await _authRepository.tryAutoLogin();
    notifyListeners();
    return _isAuthenticated;
  }

  Future<void> logout() async {
    await _authRepository.logout();

    _isAuthenticated = false;
  }

  Future<String> forgetPassword(String email) async {
    return await _authRepository.forgetPassword(email);
  }
}
