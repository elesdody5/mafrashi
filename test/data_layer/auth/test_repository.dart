// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_data_interface.dart';
import 'package:mafrashi/data_layer/repository/auth_repository.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/user.dart';

import 'fake_remote_data.dart';
import 'fake_user_manger.dart';

List<User> _users = [User(email: "elesdody"), User(email: "ahmed")];
User user = User();
UserManager fakeUserManger = FakeUserManager(user);
AuthApi fakeRemoteDataSource = FakeRemoteDataSource(_users);
AuthRepository authRepository =
    AuthRepositoryImp(fakeUserManger, fakeRemoteDataSource);

void main() {
  test('signUp new  user return true', () async {
    // signUP user
    bool result =
        await authRepository.signUp(firstName: "ahmed", email: "new@gmail");
    expect(true, result);
  });

  test('signUp existing  user throws exception', () {
    // signUP user
    expect(authRepository.signUp(firstName: "ahmed", email: "elesdody"),
        throwsA(Exception));
  });

  test('login exists  user return true', () async {
    expect(await authRepository.login("elesdody", "pass"), true);
  });
  test('login  user throws exception if not found', () {
    expect(authRepository.login("mohamed", "pass"), throwsA(Exception));
  });
}
