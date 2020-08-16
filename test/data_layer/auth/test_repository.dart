// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_api_data.dart';
import 'package:mafrashi/data_layer/repository/auth_repository.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';

import 'fake_user_manger.dart';

String _email = "eles@ele.com";
String password = "password";
String _token;

UserManager fakeUserManger =
    FakeUserManager(email: _email, token: _token, password: password);
AuthRepository authRepository = AuthRepositoryImp(fakeUserManger, AuthApiImp());

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
    expect(await authRepository.login("eles@ele.com", "password"), true);
  });
  test('login user and return expected token', () async {
    await authRepository.login("eles@ele.com", "password");

    String token = await fakeUserManger.getToken();
    expect(token.isNotEmpty, true);
  });
  test('login  user throws exception if not found', () {
    expect(authRepository.login("mohamed", "pass"), throwsA(Exception));
  });
  test("auto login when email and password save  ", () async {
    bool result = await authRepository.tryAutoLogin();
    expect(result, true);
  });
}
