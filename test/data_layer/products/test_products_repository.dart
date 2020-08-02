import 'package:flutter_test/flutter_test.dart';
import 'package:mafrashi/data_layer/remote_data/network_interface.dart';
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/data_layer/shared_prefrences/user_manager_interface.dart';
import 'package:mafrashi/model/product.dart';
import 'package:mafrashi/model/user.dart';

import '../auth/fake_user_manger.dart';
import 'fake_remote_data.dart';

List<Product> _products = [Product(id: 1), Product(id: 2)];
User user = User(id: 1);
UserManager fakeUserManger = FakeUserManager(user);
RemoteDataSource fakeRemoteDataSource = FakeRemoteData(_products);
ProductRepository productRepository =
    ProductRepository(fakeRemoteDataSource, fakeUserManger);

void main() {
  test('fetch user data and get list of 2 products', () async {
    List<Product> productList = await productRepository.fetchProducts();
    expect(2, productList.length);
    expect(1, productList[0].id);
    expect(2, productList[1].id);
  });
}
