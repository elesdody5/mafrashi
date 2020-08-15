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
}
