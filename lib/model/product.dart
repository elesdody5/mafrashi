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
  final List<ProductColor> colors;
  final List<ProductSize> sizes;
  final List<ProductVariant> varints;

  Product(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.colors,
      this.sizes,
      this.varints,
      this.isFavorite = false,
      this.inStock,
      this.review});

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    List<ProductColor> colors = [];
    List<ProductSize> sizes = [];
    List<ProductVariant> variants = [];
    final variantsJson = json['variants'];
    if (variantsJson != null)
      variantsJson
          .forEach((variant) => variants.add(ProductVariant.fromJson(variant)));
    if (json.containsKey("super_attributes")) {
      final superAttributes = json['super_attributes'] as List<dynamic>;
      final colorJson = json['super_attributes'][0]['options'];
      colorJson.forEach((color) => colors.add(ProductColor.fromJson(color)));
      if (superAttributes.length > 1) {
        final sizeJson = json['super_attributes'][1]['options'];
        sizeJson.forEach((size) => sizes.add(ProductSize.fromJson(size)));
      }
    }
    return Product(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["formated_price"],
        imageUrl: json["base_image"]["original_image_url"],
        inStock: json["in_stock"],
        review: Review.formJson(json['reviews']),
        colors: colors,
        sizes: sizes,
        varints: variants);
  }

  List<ProductColor> extractProductColor(Map<String, dynamic> productJson) {
    return colors;
  }

  List<ProductSize> extractProductSize(Map<String, dynamic> productJson) {
    List<ProductSize> sizes = [];
    final sizeJson = productJson['super_attributes'][1]['options'];
    sizeJson.forEach((color) => sizes.add(ProductSize.fromJson(productJson)));
    return sizes;
  }
}

class Review {
  int total;

  Review(this.total);

  factory Review.formJson(Map<String, dynamic> json) => Review(json['total']);
}

class ProductColor {
  int id;
  String name;

  ProductColor({this.id, this.name});

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
        id: json["id"],
        name: json["admin_name"],
      );
}

class ProductSize {
  int id;
  String name;

  ProductSize({this.id, this.name});

  factory ProductSize.fromJson(Map<String, dynamic> json) => ProductSize(
        id: json["id"],
        name: json["admin_name"],
      );
}

class ProductVariant {
  int id;
  String name;

  ProductVariant({this.id, this.name});

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        id: json["id"],
        name: json["name"],
      );
}
