import 'package:flutter/material.dart';

class Cart {
  final int id;
  final String title;
  final int productId;
  final int quantity;
  final String price;
  final int colorId;
  final int sizeId;
  String formattedTax;
  String formattedDiscount;

  Cart(
      {@required this.id,
      @required this.productId,
      @required this.title,
      @required this.quantity,
      @required this.price,
      this.formattedTax,
      this.formattedDiscount,
      this.colorId,
      this.sizeId});

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        id: json['id'],
        productId: json['id'],
        title: json['name'],
        quantity: int.parse(json['additional']['quantity']),
        price: json['price']);
  }
}
