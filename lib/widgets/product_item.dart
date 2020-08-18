import 'package:flutter/material.dart';
import 'package:mafrashi/widgets/authenticated_widget.dart';
import 'package:mafrashi/widgets/cart_dialog.dart';

import '../model/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product _product;

  ProductItem(this._product);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: _product.id,
            );
          },
          child: Hero(
            tag: _product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/photo.png'),
              image: NetworkImage(_product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.white,
          title: Text(
            _product.name ?? "",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          trailing: AuthenticatedWidget(
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                showDialog(
                    context: context, builder: (ctx) => CartDialog(_product));
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
