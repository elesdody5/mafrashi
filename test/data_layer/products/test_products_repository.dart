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
    "eyJpdiI6ImdnTlZ5T0d3bGJnUGhYaFczVXpYamc9PSIsInZhbHVlIjoiaGd6RW55a3I5XC8zK1FNSlNBR1dXT2xFMVFUQ05uM0tzd3FqdkpzSVVRc2dyd1hFa2tWejYrZ0NaNk5cL1ozb3RXIiwibWFjIjoiNDllMTBjZTI3NTgyZjQ0ZDcwODU2YTU3YTNkYTJhYzk2OTAxY2JiNTA4NTk5OTc1NDM4ZWVmNmJlZmQ2Yjc1OSJ9";

Map<String, dynamic> shippingAddress = {
  "billing": {
    "company_name": "Cmpany",
    "first_name": "Ahmed",
    "last_name": "Elesdody",
    "email": "elesdody5@gmail.com",
    "address1": {"": "Address"},
    "city": "City",
    "country": "Yemen",
    "state": "Ztate",
    "postcode": "12345",
    "phone": "01066568187",
    "use_for_shipping": "1"
  },
  "shipping": {
    "first_name": "Ahmed",
    "last_name": "Elesdody",
    "email": "elesdody5@gmail.com",
    "address1": {"": "Address"},
    "city": "City",
    "country": "Yemen",
    "state": "State",
    "postcode": "12345",
    "phone": "01066568187"
  },
  "shipping_method": "flaterate"
};

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
    final list = await productRepository.fetchProductsFromCategory("segad");
    expect(list.isNotEmpty, true);
  });
  test("fetch sub category from category", () async {
    final list = await productRepository.fetchSubCategories("1");
    expect(list.isNotEmpty, true);
  });

  test('fetch product by id ', () async {
    final product = await _remoteDataSource.fetchProductById(12);
    expect(product != null, true);
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
  test('remove cart Item ', () async {
    final result = await productRepository.removeFromCart(88);
    expect(result, true);
  });
  test("checkout when cart in items", () async {
    final result = await productRepository.order();
    expect(result, true);
  });
  test('get countries', () async {
    final contries = await productRepository.countries();
    expect(contries.isNotEmpty, true);
  });

  test('save address', () async {
    final result = await productRepository.saveAddress(shippingAddress);
    expect(result, true);
  });
  test('make order ', () async {
    final result = await productRepository.order();
    expect(result, true);
  });
}
