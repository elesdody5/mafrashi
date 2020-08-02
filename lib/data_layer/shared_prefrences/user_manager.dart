/*
* This class responsible for dealing with user data throw the application
* */
import 'dart:convert';

import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const USER = 'user';

class UserManagerImp implements UserManager {
  Future<void> saveUserData(User user) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(USER, jsonEncode(user.toJson()));
  }

  @override
  Future<void> deleteUserData() {
    // TODO: implement deleteUserData
    return null;
  }

  @override
  Future<User> getUserData() {
    // TODO: implement getUserData
    return null;
  }
}
