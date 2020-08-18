import 'package:flutter/material.dart';

class Cart {
  final int id;
  final String title;
  final int productId;
  final int quantity;
  final String price;
  final int colorId;
  final int sizeId;

  Cart(
      {@required this.id,
      @required this.productId,
      @required this.title,
      @required this.quantity,
      @required this.price,
      this.colorId,
      this.sizeId});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        id: json['id'],
        productId: json['additional']['product_id'],
        title: json['name'],
        quantity: json['additional']['quantity'],
        price: json['price']);
  }
}
