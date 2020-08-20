import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/model/cart.dart';
import 'package:mafrashi/model/order.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  ProductRepository _productRepository;
  Orders(this._productRepository);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {

  }

  Future<void> addOrder() async {
   await _productRepository.checkOut();
//    _orders.insert(
//      0,
//      Order(
//        id: json.decode(response.body)['name'],
//        amount: total,
//        dateTime: timestamp,
//        products: cartProducts,
//      ),
//    );
    notifyListeners();
  }
}
