import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/widgets/authenticated_widget.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product _product;

  ProductItem(this._product);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
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
            _product.name,
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          trailing: AuthenticatedWidget(
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addItem(_product.id, _product.price, _product.name);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context).translate('added_cart'),
                    ),
                    duration: Duration(seconds: 2),
                    action: SnackBarAction(
                      label: AppLocalizations.of(context).translate('undo'),
                      onPressed: () {
                        cart.removeSingleItem(_product.id);
                      },
                    ),
                  ),
                );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }
}
