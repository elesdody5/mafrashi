import 'package:flutter/material.dart';
import 'package:mafrashi/model/category.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:mafrashi/screens/category_screen.dart';
import 'package:provider/provider.dart';

class CategoryItem extends StatelessWidget {
  final Category _category;

  CategoryItem(this._category);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final selectedId = productsData.selectedCategoryId;
    final isSelected = _category.id == selectedId ? true : false;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          CategoryScreen.routeName,
          arguments: _category.id,
        );
      },
      child: Chip(
        label: Text(_category.name),
        labelStyle: TextStyle(color: Colors.white),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
