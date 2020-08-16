import 'package:flutter_test/flutter_test.dart';
import 'package:mafrashi/data_layer/remote_data/product_data/product_api.dart';
import 'package:mafrashi/data_layer/remote_data/product_data/product_interface.dart';
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';

import '../auth/fake_user_manger.dart';

String _email = "eles@ele.com";
String _token =
    "eyJpdiI6IlhwTlVFbW5pcjNYUnE3MzJrcDdTWEE9PSIsInZhbHVlIjoiRDhlZm1PR1h1anNXeTFUOWJuNWdQUjN3dW16emhxNHhYbVFlSFh3a29jS0M0ZnR1aHNmalNXRHFzM0RYbUFSdyIsIm1hYyI6Ijg5ZWRjNzAyOWFmMmUxN2ZlNzVlNzc0MjdmNzBiZDA5NjIxMWYxNGJmNmE4ZWY1NzA0ZGMzNThhMjdkNzJhNzkifQ";
UserManager fakeUserManger = FakeUserManager(email:_email, token: _token);
RemoteDataSource _remoteDataSource = ProductApi();
Repository productRepository =
    ProductRepository(_remoteDataSource, fakeUserManger);

void main() {
  test('fetch user data and get list of  products', () async {
    List<Product> productList = await productRepository.fetchProducts();

    expect(productList.isNotEmpty, true);
  });
  test('fetch category expected not empty list', () async {
    List<Category> categoryList = await productRepository.fetchCategory();

    expect(categoryList.isNotEmpty, true);
  });

  test("add product to wish list ", () async {
    bool result = await productRepository.addToWishList(5);
    expect(result, true);
  });
  test("fetch product according to category", () async {
    final list = await productRepository.fetchProductsFromCategory("mlayat");
    expect(list.isNotEmpty, true);
  });
  test("fetch sub category from category", () async {
    final list = await productRepository.fetchSubCategories("1");
    expect(list.isNotEmpty, true);
  });
}
