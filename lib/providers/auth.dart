import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
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
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _isAuthenticated = false;
  }
}
