import 'package:flutter/material.dart';
import 'package:mafrashi/data_layer/remote_data/product_data/product_interface.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/cart.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';
import 'package:mafrashi/model/sub_category.dart';

class ProductRepository with ChangeNotifier implements Repository {
  RemoteDataSource _remoteDataSource;
  UserManager _userManager;

  ProductRepository(this._remoteDataSource, this._userManager);

  @override
  Future<List<Product>> fetchProducts() async {
    return await _remoteDataSource.fetchProducts();
  }

  @override
  Future<List<Category>> fetchCategory() async {
    return await _remoteDataSource.fetchCategory();
  }

  @override
  Future<bool> addToWishList(int productId) async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.addToWishList(productId, token);
  }

  @override
  Future<List<Product>> fetchWishList() async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.fetchWishList(token);
  }

  @override
  Future<List<Product>> fetchProductsFromCategory(String categorySlug) async {
    return await _remoteDataSource.fetchProductsFromCategory(categorySlug);
  }

  @override
  Future<List<SubCategory>> fetchSubCategories(int categoryID) async {
    return await _remoteDataSource.fetchSubCategories(categoryID);
  }

  @override
  Future<bool> addToCart(int productId, int quantity, int colorId, int sizeId,
      int variantId) async {
    String token = await _userManager.getToken();
    await _remoteDataSource.addToCart(
        token, productId, quantity, colorId, sizeId, variantId);
    return true;
  }

  @override
  Future<Cart> fetchCartList() async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.fetchCartList(token);
  }

  @override
  Future<bool> order() async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.order(token);
  }

  @override
  Future<bool> removeFromCart(int productId) async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.removeFromCart(token, productId);
  }

  @override
  Future<String> addCoupon(int code) async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.addCoupon(token, code);
  }

  @override
  Future<List<String>> countries() async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.getCountries(token);
  }

  @override
  Future<bool> saveAddress(Map<String, dynamic> shippingAddress) async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.saveAddress(token, shippingAddress);
  }

  @override
  Future<List<Product>> fetchProductFromSubCategory(
      String categorySlug, String subCategorySlug) async {
    return await _remoteDataSource.fetchProductFromSubCategory(
        categorySlug, subCategorySlug);
  }

  @override
  Future<List<Product>> fetchOffersAndDiscount() async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.fetchOffersAndDiscount(token);
  }

  @override
  Future<String> deleteCoupon() async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.deleteCoupon(token);
  }

  Future<bool> moveFromCartToWishList(int cartId) async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.moveFromCartToWishList(token, cartId);
  }

  @override
  Future<bool> createProductReview(
      String productId, String rating, String title, String comment) async {
    String token = await _userManager.getToken();
    return await _remoteDataSource.createProductReview(
        token, productId, rating, title, comment);
  }
}
