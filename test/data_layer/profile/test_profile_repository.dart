import 'package:flutter_test/flutter_test.dart';
import 'package:mafrashi/data_layer/remote_data/user_data/user_api.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/data_layer/repository/user_repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/user.dart';

import '../auth/fake_user_manger.dart';

String _email = "eles@ele.com";
String _token =
    "eyJpdiI6InJMdUsxS1IzK1g2MUhBWFpcLzJ1dlF3PT0iLCJ2YWx1ZSI6IlBwZklaTVwvZmFnRExNd1JrdXR5aGtqblMraXZ3cDBiWTkybGNWbXNoNDZVa3Z2YXk0WUpCNFM1eE42eTl5ZHFnIiwibWFjIjoiNmI0NWFiZjI4MjUzNDJlYTA5OWNlZTlmZjEzN2I2NTdmNThlYTU4YTYyN2I5OTQ1MzA0NjQxMWYwNjRkZTZhZSJ9";
UserManager fakeUserManger = FakeUserManager(email: _email, token: _token);
ProfileApi _remoteDataSource = ProfileApiImp();
ProfileRepository profileRepository =
    ProfileRepositoryImp(fakeUserManger, _remoteDataSource);

void main() {
  test("get user data ", () async {
    User user = await profileRepository.fetchUserData();
    print(user);
    expect(user != null, true);
  });
  test('update user data', () async {
    bool result = await profileRepository.editProfile(
        firstName: "Ahmed",
        lastName: "elesd",
        email: "eles@ele.com",
        gender: "male",
        password: "password",
        confirmPassword: "password",
        phone: "01066568187",
        dateOfBirth: "12-08-1996");
    expect(result, true);
  });
}
