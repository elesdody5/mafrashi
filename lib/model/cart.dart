import 'package:flutter/material.dart';

class Cart {
  final int id;
  String formattedSubTotal;
  String formattedGrandTotal;
  String formattedTax;
  String formattedDiscount;
  List<CartItem> cartItems;

  Cart(
      {this.id,
      this.formattedSubTotal,
      this.formattedGrandTotal,
      this.formattedTax,
      this.formattedDiscount,
      this.cartItems});
  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
        id: json['id'],
        formattedSubTotal: json['formated_sub_total'],
        formattedGrandTotal: json['formated_grand_total'],
        formattedDiscount: json['formated_discount'],
        formattedTax: json['tax_total']);
  }
}

class CartItem {
  final String title;
  final int productId;
  final int quantity;
  final String price;
  final int colorId;
  final int sizeId;

  CartItem(
      {@required this.productId,
      @required this.title,
      @required this.quantity,
      @required this.price,
      this.colorId,
      this.sizeId});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        productId: json['id'],
        title: json['name'],
        quantity: int.parse(json['quantity']),
        price: json['price']);
  }
}
