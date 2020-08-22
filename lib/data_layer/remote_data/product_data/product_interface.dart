import 'package:mafrashi/model/cart.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';
import 'package:mafrashi/model/sub_category.dart';

abstract class RemoteDataSource {
  Future<List<Product>> fetchProducts();
  Future<Product> fetchProductById(int productId);
  Future<List<Category>> fetchCategory();
  Future<bool> addToWishList(int productId, String token);
  Future<List<Product>> fetchWishList(String token);
  Future<List<SubCategory>> fetchSubCategories(int categoryId);
  Future<List<Product>> fetchProductFromSubCategory(
      String categorySlug, String subCategorySlug);
  Future<List<Product>> fetchProductsFromCategory(String categorySlug);
  Future<bool> addToCart(String token, int productId, int quantity, int colorId,
      int sizeId, int variantId);
  Future<List<Cart>> fetchCartList(String toke);
  Future<bool> removeFromCart(String toke, int productId);
  Future<bool> order(String token);
  Future<bool> removeCartItems(String token);
  Future<String> addCoupon(String token, int code);
  Future<List<String>> getCountries(String token);
  Future<bool> saveAddress(String token, Map<String, dynamic> shippingAddress);
  Future<bool> saveShipping();
}
