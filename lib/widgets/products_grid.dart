import 'package:flutter/material.dart';
import 'package:mafrashi/model/product.dart';

import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  List<Product> products;
  ProductsGrid(this.products);
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(products[i]),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: .5,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
    );
  }
}
