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
  final int id;
  final String title;
  var productId;
  final int quantity;
  final String price;
  final int colorId;
  final int sizeId;

  CartItem(
      {@required this.id,
      @required this.productId,
      @required this.title,
      @required this.quantity,
      @required this.price,
      this.colorId,
      this.sizeId});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        id: json['id'],
        productId: json['additional']['product_id'],
        title: json['name'],
        quantity: int.parse(json['quantity']),
        price: json['price']);
  }
}
