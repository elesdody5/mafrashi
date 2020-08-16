import 'package:flutter_test/flutter_test.dart';
import 'package:mafrashi/data_layer/remote_data/user_data/user_api.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/data_layer/repository/user_repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/user.dart';

import '../auth/fake_user_manger.dart';

String _email = "eles@ele.com";
String _token =
    "eyJpdiI6IjBYZmdHTSsxNVptTGR3XC9ZYnNlREpBPT0iLCJ2YWx1ZSI6IjM5Z0pWWUY0aFRPNFlBRml3WlVDSFgxcHlsc1RJQitHNG0wWjUwK21ZVGdMb2VLNGlaeDBnZjVlTnJ2NjhPbFciLCJtYWMiOiJkZTY1ZDBmZWU1NGQ3YjI4MDU2N2MxMzk4ZTVkYjUwM2MxYzlkZTQyMmVjZGQwYzRlYmFjNDJiOGMxMzY4YTZiIn0";
UserManager fakeUserManger = FakeUserManager(email: _email, token: _token);
ProfileApi _remoteDataSource = ProfileApiImp();
ProfileRepository productRepository =
    ProfileRepositoryImp(fakeUserManger, _remoteDataSource);

void main() {
  test("get user data ", () async {
    User user = await productRepository.fetchUserData();
    print(user);
    expect(user != null, true);
  });
}
