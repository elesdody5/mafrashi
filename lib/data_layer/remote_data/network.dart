import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mafrashi/data_layer/remote_data/apis/auth_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/apis/product_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/network_interface.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';

class Network implements RemoteDataSource {
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

  void _addAuthorizationToHeader(String token) {
    header['Authorization'] = 'Bearer $token';
  }
}
