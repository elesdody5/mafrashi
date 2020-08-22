import 'package:flutter/material.dart';
import 'package:mafrashi/providers/category_provider.dart';
import 'package:mafrashi/widgets/sub_category_item.dart';
import 'package:provider/provider.dart';

class SubCategoryGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final categoriesData =
        Provider.of<CategoryProvider>(context, listen: false);
    final categories = categoriesData.subCategory;
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(10.0),
      itemCount: categories.length,
      itemBuilder: (ctx, i) => SubCategoryItem(categories[i]),

//      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//        crossAxisCount: 4,
//        childAspectRatio: 1,
//        crossAxisSpacing: .5,
//        mainAxisSpacing: 1,
//      ),
    );
  }
}
