import 'package:flutter/material.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:mafrashi/widgets/category_item.dart';
import 'package:provider/provider.dart';

class CategoriesGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final categories = productsData.categories;
    return GridView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(10.0),
      itemCount: categories.length,
      itemBuilder: (ctx, i) => CategoryItem(categories[i]),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
    );
  }
}
