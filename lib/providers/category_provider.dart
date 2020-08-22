import 'package:flutter/material.dart';
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/product.dart';
import 'package:mafrashi/model/sub_category.dart';

class CategoryProvider with ChangeNotifier {
  ProductRepository _productRepository;
  List<Category> _categories = [];
  List<SubCategory> _suCategory = [];
  List<Product> _productCategory = [];
  List<Product> _productSubCategory = [];
  String _currentCategorySlug;

  String get currentCategorySlug => _currentCategorySlug;

  set currentCategorySlug(String value) {
    _currentCategorySlug = value;
  }

  List<Product> get productSubCategory {
    return [..._productSubCategory];
  }

  List<Product> get productCategory {
    return [..._productCategory];
  }

  CategoryProvider(this._productRepository);

  List<Category> get categories {
    return [..._categories];
  }

  List<SubCategory> get subCategory {
    return [..._suCategory];
  }

  Category findCategoryById(int id) {
    return _categories.firstWhere((cat) => cat.id == id);
  }

  Future<void> fetchCategories() async {
    _categories = await _productRepository.fetchCategory();
    notifyListeners();
  }

  Future<void> fetchSubCategory(int categoryId) async {
    _suCategory = await _productRepository.fetchSubCategories(categoryId);
    notifyListeners();
  }

  Future<void> fetchProductsByCategory(String catSlug) async {
    _productCategory =
        await _productRepository.fetchProductsFromCategory(catSlug);
    notifyListeners();
  }

  Future<void> fetchProductsBySubCategory(
      String categorySlug, String subCategorySlug) async {
    _productSubCategory = await _productRepository.fetchProductFromSubCategory(
        categorySlug, subCategorySlug);
    notifyListeners();
  }
}
