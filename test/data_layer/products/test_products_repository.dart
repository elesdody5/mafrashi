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
    "eyJpdiI6InlWM3F1aEIzbldlVUM4VVR5YlM3TWc9PSIsInZhbHVlIjoiOFdXc3Z3ZHV0WmNOK0lXRUtYMDRocGp0bU5QZHp5aEFOZEQzUzFGUGpBUWtUanVZRHBIeExcLzdkbk9iaHowTGQiLCJtYWMiOiIyYjk0NGYxZTBkMDAzMDM5YmMwNDBkMWEyYmZmNWRmZDkwMWRlNWMyZDEyNDI5NjM3ZmFlZjAyMzcyYzk2ZThkIn0";
UserManager fakeUserManger = FakeUserManager(email: _email, token: _token);
RemoteDataSource _remoteDataSource = ProductApi();
Repository productRepository =
    ProductRepository(_remoteDataSource, fakeUserManger);

void main() {
  test('fetch user data and get list of  products', () async {
    List<Product> productList = await productRepository.fetchProducts();

    expect(productList.isNotEmpty, true);
  });
  test('fetch product and get non null colors ', () async {
    List<Product> productList = await productRepository.fetchProducts();
    print(productList[0].colors[0].name);
    expect(productList[0].colors[0].name, "red");
  });
  test('fetch category expected not empty list', () async {
    List<Category> categoryList = await productRepository.fetchCategory();
    print(categoryList[0].slug);
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
  test("fetch wish list ", () async {
    final list = await productRepository.fetchWishList();
    expect(list.isNotEmpty, true);
  });
  test('add product to cart ', () async {
    final message = await productRepository.addToCart(3, 1, 2, 4, 13);
    expect(message, true);
  });
  test('fetch cart list ', () async {
    final cartList = await productRepository.fetchCartList();
    expect(cartList.isNotEmpty, true);
  });
}
