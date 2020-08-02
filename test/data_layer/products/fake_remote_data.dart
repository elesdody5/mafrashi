import 'package:mafrashi/data_layer/remote_data/network_interface.dart';
import 'package:mafrashi/model/product.dart';

class FakeRemoteData implements RemoteDataSource {
  List<Product> _products;
  FakeRemoteData(this._products);
  @override
  Future<List<Product>> fetchProducts() async {
    return _products;
  }
}
