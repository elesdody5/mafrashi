import 'package:flutter/material.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  List<Category> _categories = [];

  List<Category> get categories => _categories;
  Repository _productRepository;

  ProductsProvider(this._productRepository);

  List<Product> get items {
    return [..._items];
  }

  int _selectedCategoryId;

  set selectedCategoryId(int value) {
    _selectedCategoryId = value;
    notifyListeners();
  }

  int get selectedCategoryId => _selectedCategoryId;

//  List<Product> get favoriteItems {
//    return _items.where((prodItem) => prodItem.isFavorite).toList();
//  }

  Product findById(int id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Category findCategoryById(int id) {
    return _categories.firstWhere((cat) => cat.id == id);
  }

  Future<void> fetchProducts() async {
    _items = await _productRepository.fetchProducts();
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    _categories = await _productRepository.fetchCategory();
    notifyListeners();
  }
}
