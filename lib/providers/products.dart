import 'package:flutter/material.dart';
import 'package:mafrashi/data_layer/repository/repository.dart';
import 'package:mafrashi/model/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];
  List<Product> _wishList = [];
  List<Product> _productCategory = [];

  List<Product> get productCategory {
    return [..._productCategory];
  }

  List<Product> get wishList {
    return [..._wishList];
  }

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

  Future<bool> addToWishList(int productId) async {
    bool result = await _productRepository.addToWishList(productId);
    if (result) {
      _wishList.add(findById(productId));
    } else {
      Product product =
          _wishList.firstWhere((product) => product.id == productId);
      _wishList.remove(product);
    }
    notifyListeners();
    return result;
  }

  Future<void> fetchWishList() async {
    if (_wishList.isEmpty) {
      _wishList = await _productRepository.fetchWishList();
      notifyListeners();
    }
  }

  bool isFavourite(int productId) {
    Product product = _wishList.firstWhere((product) => product.id == productId,
        orElse: () => null);
    if (product != null)
      return true;
    else
      return false;
  }

  Product findById(int id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchProducts() async {
    if (_items.isEmpty) _items = await _productRepository.fetchProducts();
    notifyListeners();
  }

  Future<void> fetchProductsByCategory(String catSlug) async {
    _productCategory =
        await _productRepository.fetchProductsFromCategory(catSlug);
    notifyListeners();
  }
}
