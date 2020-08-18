import 'package:mafrashi/model/cart.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';
import 'package:mafrashi/model/sub_category.dart';

abstract class RemoteDataSource {
  Future<List<Product>> fetchProducts();
  Future<List<Category>> fetchCategory();
  Future<bool> addToWishList(int productId, String token);
  Future<List<Product>> fetchWishList(String token);
  Future<List<SubCategory>> fetchSubCategories(String categorySlug);
  Future<List<Product>> fetchProductsFromCategory(String categorySlug);
  Future<bool> addToCart(String token, int productId, int quantity, int colorId,
      int sizeId, int variantId);
  Future<List<Cart>> fetchCartList(String toke);
}
