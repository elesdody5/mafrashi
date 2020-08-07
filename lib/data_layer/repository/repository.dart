import 'package:flutter/material.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';

abstract class AuthRepository {
  Future<bool> login(String email, String password);

  Future<bool> logout();

  Future<bool> signUp(
      {@required String firstName,
      @required String lastName,
      @required String email,
      @required String gender,
      @required String password,
      @required String confirmPassword,
      @required String phone,
      @required String dateOfBirth});
}

abstract class Repository {
  Future<List<Product>> fetchProducts();
  Future<List<Category>> fetchCategory();
  Future<bool> addToWishList(int productId);
}
