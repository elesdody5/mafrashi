import 'package:flutter/material.dart';
import 'package:mafrashi/data_layer/remote_data/user_data/user_api.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/user.dart';

class ProfileRepositoryImp with ChangeNotifier implements ProfileRepository {
  ProfileApi _remoteDataSource;
  UserManager _userManager;

  ProfileRepositoryImp(this._userManager, this._remoteDataSource);

  @override
  Future<User> fetchUserData() async {
    String token = await _userManager.getToken();
    return _remoteDataSource.fetchUserData(token);
  }

  @override
  Future<bool> editProfile(
      {String firstName,
      String lastName,
      String email,
      String gender,
      String password,
      String confirmPassword,
      String phone,
      String dateOfBirth}) async {
    String token = await _userManager.getToken();
    return _remoteDataSource.editProfile(token, firstName, lastName, email,
        gender, password, confirmPassword, phone, dateOfBirth);
  }
}
