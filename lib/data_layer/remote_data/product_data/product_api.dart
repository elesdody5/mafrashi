import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mafrashi/data_layer/remote_data/apis/auth_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/apis/product_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/product_data/product_interface.dart';
import 'package:mafrashi/model/cart.dart';
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
    final response = await http.get(url);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData == null) {
      return productList;
    }
    final data = responseData['data'];

    data.forEach(
        (productJson) => productList.add(Product.fromJson(productJson)));
    return productList;
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
    final response = await http.get(url, headers: header);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData['message'] == "Item removed from wishlist successfully.")
      return false;
    if (responseData['message'] == "Item Successfully Added To Wishlist")
      return true;
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
    print(categorySlug);
    var url = BASE_URL + PRODUCT_CATEGORY + categorySlug;
    List<Product> productList = [];

    final response = await http.get(url);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData == null) {
      return productList;
    }
    final data = responseData['data'];
    for (var productJson in data) {
      String productId = productJson['product_id'];
      Product product = await fetchProductById(int.parse(productId));
      productList.add(product);
    }
    return productList;
  }

  @override
  Future<List<Product>> fetchWishList(String token) async {
    var url = BASE_URL + WISHLIST;
    _addAuthorizationToHeader(token);
    List<Product> productList = [];
    try {
      final response = await http.get(url, headers: header);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null) {
        return productList;
      }
      final data = responseData['data'];
      if (data != null) {
        data.forEach((productJson) =>
            productList.add(Product.fromJson(productJson['product'])));
      }
      return productList;
    } catch (error) {
      throw (error);
    }
  }

  @override
  Future<bool> addToCart(String token, int productId, int quantity, int colorId,
      int sizeId, int variantId) async {
    var url = BASE_URL + ADD_CART + '$productId';
    _addAuthorizationToHeader(token);
    try {
      final response = await http.post(url,
          headers: header,
          body: json.encode({
            "quantity": quantity,
            "product_id": productId,
            "color": colorId,
            "size": sizeId,
            "selected_configurable_option": variantId
          }));
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 && responseData['error'] == null)
        return true;
    } catch (error) {
      throw (error);
    }
    return false;
  }

  @override
  Future<List<Cart>> fetchCartList(String token) async {
    var url = BASE_URL + CART_ITEM;
    _addAuthorizationToHeader(token);
    List<Cart> cartList = [];

    final response = await http.get(url, headers: header);
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    if (responseData == null) {
      return cartList;
    }
    final data = responseData['data'];
    if (data == null) return cartList;
    final items = data['items'];

    items.forEach((cartJson) => cartList.add(Cart.fromJson(cartJson)));
    return cartList;
  }

  @override
  Future<bool> removeFromCart(String token, int productId) async {
    var url = BASE_URL + REMOVE_CART_ITEM + '$productId';
    _addAuthorizationToHeader(token);
    final response = await http.get(url, headers: header);
    print(response.body);
    if (response.statusCode == 200) return true;

    return false;
  }

  @override
  Future<bool> checkOut(String token) async {
    var url = BASE_URL + CHECK_OUT_ORDER;
    _addAuthorizationToHeader(token);
    final response = await http.post(url,
        headers: header,
        body: json.encode({"shipping_method": "flatrate_flatrate"}));
    if (response.statusCode == 200) {
      // remove all product from cart after order
      bool emptyCart = await removeCartItems(token);
      if (emptyCart)
        return true;
      else
        return false;
    }
    return false;
  }

  @override
  Future<bool> removeCartItems(String token) async {
    var url = BASE_URL + EMPTY_CART;
    _addAuthorizationToHeader(token);
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) return true;
    return false;
  }

  @override
  Future<Product> fetchProductById(int productId) async {
    var url = BASE_URL + PRODUCT_BY_ID + '$productId';
    final response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      Product product = Product.fromJson(responseData['data']);
      return product;
    }
    return null;
  }

  @override
  Future<String> addCoupon(String token, int code) async {
    var url = BASE_URL + APPLY_COUPON;
    _addAuthorizationToHeader(token);
    final response = await http.post(url,
        headers: header, body: json.encode({"code": code}));
    final responseData = json.decode(response.body);
    if (responseData['message'] != null) {
      return responseData['message'];
    }
    return null;
  }

  void _addAuthorizationToHeader(String token) {
    header['Cookie'] = 'mafrashi_session=$token';
  }
}
