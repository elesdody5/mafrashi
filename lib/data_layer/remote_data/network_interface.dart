import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';

abstract class RemoteDataSource {
  Future<List<Product>> fetchProducts();
  Future<List<Category>> fetchCategory();
  Future<bool> addToWishList(int productId, String token);
}
