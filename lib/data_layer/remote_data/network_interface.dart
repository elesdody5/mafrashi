import 'package:mafrashi/model/product.dart';

abstract class RemoteDataSource {
  Future<List<Product>> fetchProducts();
}
