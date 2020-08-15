import 'package:flutter/material.dart';
import 'package:mafrashi/data_layer/repository/products_repository.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/model/sub_category.dart';

class CategoryProvider with ChangeNotifier {
  ProductRepository _productRepository;
  List<Category> _categories = [];
  List<SubCategory> _suCategory = [];
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

  Future<void> fetchSubCategory(String categorySlug) async {
    _suCategory = await _productRepository.fetchSubCategories(categorySlug);
    notifyListeners();
  }
}
