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
}
