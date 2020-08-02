import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mafrashi/data_layer/remote_data/apis/auth_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/apis/product_api_urls.dart';
import 'package:mafrashi/data_layer/remote_data/network_interface.dart';
import 'package:mafrashi/model/product.dart';

class Network implements RemoteDataSource {
  @override
  Future<List<Product>> fetchProducts() async {
    var url = BASE_URL + PRODUCTS;
    List<Product> productList = [];
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      if (responseData == null) {
        return productList;
      }
      final data = responseData['data'];

      data.forEach(
          (productJson) => productList.add(Product.fromJson(productJson)));
      return productList;
    } catch (error) {
      throw (error);
    }
  }
}
