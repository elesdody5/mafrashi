import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mafrashi/data_layer/remote_data/apis/auth_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/apis/product_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/product_data/product_interface.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';
import 'package:mafrashi/model/sub_category.dart';

class ProductApi implements RemoteDataSource {
  Map<String, String> header = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  @override
  Future<List<Product>> fetchProducts() async {
    var url = BASE_URL + PRODUCTS;
    List<Product> productList = [];
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null) {
        return productList;
      }
      final data = responseData['data'];

      data.forEach(
          (productJson) => productList.add(Product.fromJson(productJson)));
      return productList;
    } catch (error) {
      throw HttpException(error.toString(), uri: Uri.parse(url));
    }
  }

  @override
  Future<List<Category>> fetchCategory() async {
    var url = BASE_URL + CATEGORIES;
    List<Category> categoryList = [];
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null) {
        return categoryList;
      }
      final data = responseData['data'];

      data.forEach(
          (productJson) => categoryList.add(Category.fromJson(productJson)));
      return categoryList;
    } catch (error) {
      throw (error);
    }
  }

  @override
  Future<bool> addToWishList(int productId, String token) async {
    var url = BASE_URL + ADD_WISHLIST + '$productId';
    _addAuthorizationToHeader(token);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<List<SubCategory>> fetchSubCategories(String categorySlug) async {
    var url = BASE_URL + SUB_CATEGORIES + '$categorySlug';
    List<SubCategory> subCategoryList = [];
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null) {
        return subCategoryList;
      }
      final data = responseData['data'];

      data.forEach((subCategoryJson) {
        final subCategory = subCategoryJson['translation'][0];
        subCategoryList.add(SubCategory.fromJson(subCategory));
      });
      return subCategoryList;
    } catch (error) {
      throw (error);
    }
  }

  @override
  Future<List<Product>> fetchProductsFromCategory(String categorySlug) async {
    var url = BASE_URL + PRODUCT_CATEGORY + categorySlug;
    List<Product> productList = [];
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null) {
        return productList;
      }
      final data = responseData['data'];

      data.forEach(
          (productJson) => productList.add(Product.fromJson(productJson)));
      return productList;
    } catch (error) {
      throw HttpException(error.toString(), uri: Uri.parse(url));
    }
  }

  @override
  Future<List<Product>> fetchWishList(String token) async {
    var url = BASE_URL + WISHLIST;
    _addAuthorizationToHeader(token);
    List<Product> productList = [];
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null) {
        return productList;
      }
      final data = responseData['data'];

      data.forEach(
          (productJson) => productList.add(Product.fromJson(productJson)));
      return productList;
    } catch (error) {
      throw (error);
    }
  }

  void _addAuthorizationToHeader(String token) {
    header['Authorization'] = 'Bearer $token';
  }
}
