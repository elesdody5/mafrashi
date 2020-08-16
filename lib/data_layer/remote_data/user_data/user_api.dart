import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mafrashi/data_layer/remote_data/apis/auth_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/apis/user_api_urls.dart';
import 'package:mafrashi/model/user.dart';

abstract class ProfileApi {
  Future<User> fetchUserData(String token);

  Future<bool> editProfile(
      String token,
      String firstName,
      String lastName,
      String email,
      String gender,
      String password,
      String confirmPassword,
      String phone,
      String dateOfBirth);
}

class ProfileApiImp implements ProfileApi {
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<User> fetchUserData(String token) async {
    var url = BASE_URL + USER_PROFILE;
    _addAuthorizationToHeader(token);
    final response = await http.get(url, headers: header);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    print(responseData);
    final data = responseData['data'];
    return User.fromJson(data);
  }

  @override
  Future<bool> editProfile(
      String token,
      String firstName,
      String lastName,
      String email,
      String gender,
      String password,
      String confirmPassword,
      String phone,
      String dateOfBirth) async {
    try {
      var url = BASE_URL + EDIT_PROFILE;
      _addAuthorizationToHeader(token);
      final response = await http.post(
        url,
        headers: header,
        body: json.encode({
          "phone": phone,
          "first_name": firstName,
          "last_name": lastName,
          "gender": gender,
          "date_of_birth": dateOfBirth,
          "email": email,
          'password': password,
          'password_confirmation': password
        }),
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  void _addAuthorizationToHeader(String token) {
    header['Cookie'] = 'mafrashi_session=$token';
  }
}
