import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/cart.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: FutureBuilder(
          future: cart.fetchCartItems(),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.error != null) {
                // ...
                // Do error handling stuff
                return Center(
                  child: Text('An error occurred!'),
                );
              } else {
                return Consumer<CartProvider>(
                    builder: (_, cartProvider, child) {
                  if (cartProvider.items.isEmpty) {
                    return Center(
                      child: GridTile(
                        child: Image.asset('assets/images/shopping-cart.png'),
                        footer: Text(AppLocalizations.of(context)
                            .translate('empty_cart')),
                      ),
                    );
                  } else {
                    return Column(
                      children: <Widget>[
                        Card(
                          margin: EdgeInsets.all(15),
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  AppLocalizations.of(context)
                                      .translate('total'),
                                  style: TextStyle(fontSize: 20),
                                ),
                                Spacer(),
                                Chip(
                                  label: Text(
                                    '\$${cart.totalAmount.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .primaryTextTheme
                                          .title
                                          .color,
                                    ),
                                  ),
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                OrderButton(cart: cart)
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: cart.items.length,
                            itemBuilder: (ctx, i) => CartItem(
                              cart.items[i],
                            ),
                          ),
                        )
                      ],
                    );
                  }
                });
              }
            }
          }),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
//      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
//          ? null
//          : () async {
//              setState(() {
//                _isLoading = true;
//              });
//              await Provider.of<Orders>(context, listen: false).addOrder(
//                widget.cart.items.values.toList(),
//                widget.cart.totalAmount,
//              );
//              setState(() {
//                _isLoading = false;
//              });
//              widget.cart.clear();
//            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
