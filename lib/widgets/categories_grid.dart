import 'package:flutter/material.dart';
import 'package:mafrashi/providers/category_provider.dart';
import 'package:mafrashi/widgets/category_item.dart';
import 'package:provider/provider.dart';

class CategoriesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesData = Provider.of<CategoryProvider>(context);
    final categories = categoriesData.categories;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(10.0),
      itemCount: categories.length,
      itemBuilder: (ctx, i) => CategoryItem(categories[i]),

//      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//        crossAxisCount: 4,
//        childAspectRatio: 1,
//        crossAxisSpacing: .5,
//        mainAxisSpacing: 1,
//      ),
    );
  }
}
