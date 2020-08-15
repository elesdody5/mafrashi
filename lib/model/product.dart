import 'package:flutter/foundation.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  bool isFavorite;
  bool inStock;
  final Review review;

  Product(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false,
      this.inStock,
      this.review});

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        imageUrl: json["base_image"]["original_image_url"],
        inStock: json["in_stock"],
        review: Review.formJson(json['reviews']),
      );
}

class Review {
  int total;
  int totalRating;
  int averageRating;

  Review(this.total, this.totalRating, this.averageRating);

  factory Review.formJson(Map<String, dynamic> json) =>
      Review(json['total'], json['total_rating'], json['average_rating']);
}
