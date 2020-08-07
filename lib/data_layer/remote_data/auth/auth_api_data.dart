import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mafrashi/data_layer/remote_data/apis/auth_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/auth/auth_data_interface.dart';

class AuthApiImp implements AuthApi {
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<String> login(String email, String password) async {
    final url = BASE_URL + LOGIN;
    try {
      final response = await http.post(url,
          body: json.encode({'email': email, 'password': password}),
          headers: header);
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error'], uri: Uri.parse(url));
      }
      String token = _updateCookie(response);
      return token;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<bool> logout(String email) async {
    final url = BASE_URL + LOGOUT + "?email=$email";
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

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

  String _updateCookie(http.Response response) {
    String rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      String token = rawCookie.replaceFirst("mafrashi_session=", "");
      int index = token.indexOf(';');
      return (index == -1) ? token : token.substring(0, index);
    }
    return null;
  }
}
