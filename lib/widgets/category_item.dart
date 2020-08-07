import 'package:flutter/material.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatelessWidget {
  final Category _category;

  CategoryItem(this._category);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final selectedId = productsData.selectedCategoryId;
    final isSelected = _category.id == selectedId ? true : false;
    return FilterChip(
      label: Text(_category.name),
      labelStyle: TextStyle(color: Colors.white),
      selected: isSelected,
      onSelected: (bool selected) {
        productsData.selectedCategoryId = _category.id;
      },
      selectedColor: Theme.of(context).accentColor,
      checkmarkColor: Colors.white,
    );
  }
}
