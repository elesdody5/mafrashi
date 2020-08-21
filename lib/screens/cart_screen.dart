import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/cart.dart';
import 'package:mafrashi/screens/checkout_screen.dart';
import 'package:mafrashi/widgets/dialog_style.dart';
import 'package:mafrashi/widgets/form_text_field.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Image.asset('assets/images/shopping-cart.png'),
                        Text(AppLocalizations.of(context)
                            .translate('empty_cart')),
                      ]),
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                CouponButton(cart: cart)
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
                        ),
                        OrderButton(
                          cart: cart,
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

class CouponButton extends StatefulWidget {
  const CouponButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartProvider cart;

  @override
  _couponButtonState createState() => _couponButtonState();
}

class _couponButtonState extends State<CouponButton> {
  var _isLoading = false;
  final _codeController = TextEditingController();

  void _showCodeDialog() {
    Alert(
        context: context,
        style: alertStyle,
        title: AppLocalizations.of(context).translate('add_coupon'),
        content: _buildEmailTextField(),
        buttons: [
          DialogButton(
            child: _isLoading ? CircularProgressIndicator : Text("Submit"),
            onPressed: () {
              Navigator.pop(context);
              sendCode();
            },
          )
        ]).show();
  }

  Widget _buildEmailTextField() {
    return FormTextField(
      hint: "Code",
      controller: _codeController,
      validator: (value) {
        if (value.isEmpty) {
          return 'Invalid Code!';
        }
      },
    );
  }

  Future<void> sendCode() async {
    setState(() {
      _isLoading = true;
    });
    String message = await Provider.of<CartProvider>(context, listen: false)
        .addCoupon(int.parse(_codeController.text));
    setState(() {
      _isLoading = false;
    });
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              AppLocalizations.of(context).translate('add_coupon'),
            ),
      onPressed: () {
        _showCodeDialog();
      },
      textColor: Theme.of(context).primaryColor,
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

  void _showSuccessfully() {
    Alert(
      context: context,
      type: AlertType.success,
      title: AppLocalizations.of(context).translate('order_submit'),
      style: AlertStyle(isCloseButton: false),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('continue'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CupertinoButton(
        color: Theme.of(context).accentColor,
        child: _isLoading
            ? CircularProgressIndicator()
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(AppLocalizations.of(context)
                    .translate('proceed_to_checkout')),
                Icon(Icons.arrow_forward),
              ]),
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                Navigator.pushNamed(context, CheckOutScreen.routeName);
              },
      ),
    );
  }
}
