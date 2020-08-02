import 'package:flutter/material.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_data_interface.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/user.dart';

class AuthRepositoryImp with ChangeNotifier implements AuthRepository {
  AuthApi _remoteDataSource;
  UserManager _userManager;
  AuthRepositoryImp(this._userManager, this._remoteDataSource);

  @override
  Future<bool> login(String email, String password) async {
    User user = await _remoteDataSource.login(email, password);
    _userManager.saveUserData(user);
    return true;
  }

  @override
  Future<bool> logout() {
    // TODO: implement logout
    return null;
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
}
