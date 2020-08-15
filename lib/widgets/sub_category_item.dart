import 'package:flutter/material.dart';
import 'package:mafrashi/model/sub_category.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:provider/provider.dart';

class SubCategoryItem extends StatelessWidget {
  final SubCategory _subCategory;

  SubCategoryItem(this._subCategory);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final selectedId = productsData.selectedCategoryId;
    final isSelected = _subCategory.id == selectedId ? true : false;
    return GestureDetector(
//      onTap: () {
//        Navigator.of(context).pushNamed(
//          CategoryScreen.routeName,
//          arguments: _subCategory.id,
//        );
//      },
      child: Chip(
        label: Text(_subCategory.name),
        labelStyle: TextStyle(color: Colors.white),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
