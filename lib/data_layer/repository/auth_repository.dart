import 'package:flutter/material.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_data_interface.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';

class AuthRepositoryImp with ChangeNotifier implements AuthRepository {
  AuthApi _remoteDataSource;
  UserManager _userManager;

  AuthRepositoryImp(this._userManager, this._remoteDataSource);

  @override
  Future<bool> login(String email, String password) async {
    String token = await _remoteDataSource.login(email, password);
    await _userManager.saveToken(token);
    return true;
  }

  @override
  Future<bool> logout() async {
    String email = await _userManager.getUserEmail();
    bool result = await _remoteDataSource.logout(email);
    if (result) _userManager.deleteUserData();
    return result;
  }

  @override
  Future<bool> tryAutoLogin() async {
    String email = await _userManager.getUserEmail();
    String password = await _userManager.getUserPassword();
    if (email == null || password == null) return false;
    return await login(email, password);
  }

  @override
  Future<bool> signUp(
      {String firstName,
      String lastName,
      String email,
      String gender,
      String password,
      String confirmPassword,
      String phone,
      String dateOfBirth}) {
    return _remoteDataSource.signUp(
        firstName: firstName,
        lastName: lastName,
        email: email,
        gender: gender,
        phone: phone,
        dateOfBirth: dateOfBirth,
        password: password,
        confirmPassword: confirmPassword);
  }

  @override
  Future<String> forgetPassword(String email) async {
    return await _remoteDataSource.forgetPassword(email);
  }
}
