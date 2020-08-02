import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mafrashi/data_layer/remote_data/apis/auth_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_data_interface.dart';
import 'package:mafrashi/model/user.dart';

class AuthApiImp implements AuthApi {
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  @override
  Future<User> login(String email, String password) async {
    final url = BASE_URL + LOGIN;
    try {
      final response = await http.post(url,
          body: json.encode({'email': email, 'password': password}),
          headers: header);
      print(response.body);
      final responseData = json.decode(response.body);
      print("header${response.headers}");
      if (responseData['error'] != null) {
        throw HttpException(responseData['error'], uri: Uri.parse(url));
      }
      return User.fromJson(responseData['data']);
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> logout() async {}

  @override
  Future<bool> signUp(
      {@required String firstName,
      @required String lastName,
      @required String email,
      @required String gender,
      @required String password,
      @required String confirmPassword,
      @required String phone,
      @required String dateOfBirth}) async {
    final url = BASE_URL + SIGN_UP;
    try {
      final response = await http.post(
        url,
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
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error'], uri: Uri.parse(url));
      }
      return true;
    } catch (error) {
      throw error;
    }
  }
}
