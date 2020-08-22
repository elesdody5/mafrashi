import 'package:flutter/material.dart';
import 'package:mafrashi/model/cart.dart';
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
  Future<List<SubCategory>> fetchSubCategories(int categoryId);
  Future<List<Product>> fetchProductsFromCategory(String categorySlug);
  Future<bool> addToCart(
      int productId, int quantity, int colorId, int sizeId, int variantId);
  Future<List<Cart>> fetchCartList();
  Future<bool> removeFromCart(int productId);
  Future<String> addCoupon(int code);
  Future<List<String>> countries();
  Future<List<Product>> fetchProductFromSubCategory(
      String categorySlug, String subCategorySlug);
  Future<bool> saveAddress(Map<String, dynamic> shippingAddress);
  Future<bool> order();
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
