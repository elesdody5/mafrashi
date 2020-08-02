import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_data_interface.dart';
import 'package:mafrashi/model/user.dart';

class FakeRemoteDataSource implements AuthApi {
  List<User> _users;
  FakeRemoteDataSource(this._users);

  @override
  Future<User> login(String email, String password) async {
    User existuser;
    _users.forEach((user) {
      if (user.email == email) existuser = user;
    });
    if (existuser == null) throw Exception;
    return existuser;
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
      String dateOfBirth}) async {
    // throws exception if user exist
    _users.forEach((user) {
      if (user.email == email) throw Exception;
    });

    await _users.add(User(
        id: Random().nextInt(10),
        firstName: firstName,
        lastName: lastName,
        gender: gender,
        dateOfBirth: dateOfBirth,
        email: email,
        phone: phone));
    return true;
  }
}
