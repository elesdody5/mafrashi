import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mafrashi/model/cart.dart';
import 'package:mafrashi/model/order.dart';

class Orders with ChangeNotifier {
  List<Order> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://flutter-update.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    final List<Order> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
//    extractedData.forEach((orderId, orderData) {
//      loadedOrders.add(
//        Order(
//          id: orderId,
//          amount: orderData['amount'],
//          dateTime: DateTime.parse(orderData['dateTime']),
//          products: (orderData['products'] as List<dynamic>)
//              .map(
//                (item) => CartItem(
//                  id: item['id'],
//                  price: item['price'],
//                  quantity: item['quantity'],
//                  title: item['title'],
//                ),
//              )
//              .toList(),
//        ),
//      );
//    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<Cart> cartProducts, double total) async {
    final url =
        'https://flutter-update.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
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
