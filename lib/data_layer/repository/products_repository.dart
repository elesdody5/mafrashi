import 'package:flutter/material.dart';
import 'package:mafrashi/data_layer/remote_data/network_interface.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';

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
}
