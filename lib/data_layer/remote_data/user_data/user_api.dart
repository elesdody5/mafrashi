import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mafrashi/data_layer/remote_data/apis/auth_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/apis/user_api_urls.dart';
import 'package:mafrashi/model/user.dart';

abstract class ProfileApi {
  Future<User> fetchUserData(String token);
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
    final response = await http.get(url);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final data = responseData['data'];
    return User.fromJson(data);
  }

  void _addAuthorizationToHeader(String token) {
    header['Authorization'] = 'Bearer $token';
  }
}
