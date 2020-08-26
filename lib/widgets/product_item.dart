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

  String _calculatePriceDiscount(int discount, double price) {
    double newPrice = price - ((discount / 100) * price);
    return newPrice.toString();
  }

  Widget _buildPriceText() {
    TextStyle priceStyle = widget._product.discount != null
        ? TextStyle(fontSize: 20, decoration: TextDecoration.lineThrough)
        : TextStyle(fontSize: 20);

    String priceAfterDiscount = widget._product.discount != null
        ? _calculatePriceDiscount(int.parse(widget._product.discount),
            double.parse(widget._product.price.replaceFirst("SAR ", " ")))
        : "";
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            widget._product.price,
            style: priceStyle,
          ),
          Spacer(),
          if (widget._product.discount != null)
            Text(
              priceAfterDiscount,
              style: TextStyle(fontSize: 20),
            )
        ],
      ),
    );
  }

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
            child: Stack(children: [
              SizedBox.expand(
                child: Hero(
                  tag: widget._product.id,
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/photo.png'),
                    image: NetworkImage(widget._product.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (widget._product.discount != null)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/discount.png'))),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "% ${widget._product.discount}" ?? "",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      )),
                )
            ]),
          ),
          footer: Column(
            children: <Widget>[
              _buildPriceText(),
              GridTileBar(
                backgroundColor: Colors.white,
                title: Text(
                  widget._product.name ?? "",
                  style: TextStyle(color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                leading:
                    Consumer<ProductsProvider>(builder: (context, provider, _) {
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
            ],
          )),
    );
  }
}
