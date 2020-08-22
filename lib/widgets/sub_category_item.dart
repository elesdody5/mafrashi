import 'package:flutter/material.dart';
import 'package:mafrashi/model/sub_category.dart';
import 'package:mafrashi/providers/category_provider.dart';
import 'package:mafrashi/screens/sub_category_screen.dart';
import 'package:provider/provider.dart';

class SubCategoryItem extends StatelessWidget {
  final SubCategory _subCategory;

  SubCategoryItem(this._subCategory);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<CategoryProvider>(context, listen: false);
    final categorySlug = productsData.currentCategorySlug;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(SubCategoryScreen.routName, arguments: {
          "sub_category_name": _subCategory.description,
          "category_slug": categorySlug,
          "sub_category_slug": _subCategory.slug
        });
      },
      child: Chip(
        label: Text(_subCategory.description),
        labelStyle: TextStyle(color: Colors.white),
        backgroundColor: Theme.of(context).accentColor,
      ),
    );
  }
}
