import 'package:flutter/material.dart';
import 'package:mafrashi/providers/products.dart';
import 'package:mafrashi/widgets/authenticated_widget.dart';
import 'package:mafrashi/widgets/cart_dialog.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatefulWidget {
  final Product _product;
  ProductItem(this._product);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: widget._product.id,
            );
          },
          child: Hero(
            tag: widget._product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/photo.png'),
              image: NetworkImage(widget._product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.white,
          title: Text(
            widget._product.name ?? "",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
          leading: Consumer<ProductsProvider>(builder: (context, provider, _) {
            return AuthenticatedWidget(
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Icon(
                      provider.isFavourite(widget._product.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Theme.of(context).accentColor,
                    ),
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                await provider.addToWishList(widget._product.id);
                setState(() {
                  _isLoading = false;
                });
              },
            );
          }),
          trailing: AuthenticatedWidget(
            child: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (ctx) => CartDialog(widget._product));
            },
          ),
        ),
      ),
    );
  }
}
