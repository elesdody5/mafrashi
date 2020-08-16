import 'package:flutter/material.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';
import 'package:mafrashi/model/sub_category.dart';
import 'package:mafrashi/model/user.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);

  Future<bool> logout();
  Future<bool> tryAutoLogin();
  Future<bool> signUp(
      {@required String firstName,
      @required String lastName,
      @required String email,
      @required String gender,
      @required String password,
      @required String confirmPassword,
      @required String phone,
      @required String dateOfBirth});

  Future<String> forgetPassword(String email);
}

abstract class Repository {
  Future<List<Product>> fetchProducts();
  Future<List<Category>> fetchCategory();
  Future<bool> addToWishList(int productId);
  Future<List<Product>> fetchWishList();
  Future<List<SubCategory>> fetchSubCategories(String categorySlug);
  Future<List<Product>> fetchProductsFromCategory(String categorySlug);
}

abstract class ProfileRepository {
  Future<User> fetchUserData();
  Future<bool> editProfile(
      {@required String firstName,
      @required String lastName,
      @required String email,
      @required String gender,
      @required String password,
      @required String confirmPassword,
      @required String phone,
      @required String dateOfBirth});
}
