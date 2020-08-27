import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/model/cart.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemWidget extends StatelessWidget {
  CartItem _cart;
  CartItemWidget(this._cart);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(_cart.id),
      secondaryBackground: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      background: Container(
        color: Colors.green,
        child: ListTile(
          title: Text(
            AppLocalizations.of(context).translate('move_wish_list'),
            style: TextStyle(color: Colors.white),
          ),
          leading: Icon(
            Icons.favorite,
            color: Colors.white,
            size: 40,
          ),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart)
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title:
                  Text(AppLocalizations.of(context).translate('are_you_sure')),
              content: Text(
                AppLocalizations.of(context)
                    .translate('do_you_to_remove_item_cart'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).translate('no')),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text(AppLocalizations.of(context).translate('yes')),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          );
        else
          return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title:
                  Text(AppLocalizations.of(context).translate('are_you_sure')),
              content: Text(
                AppLocalizations.of(context).translate('move_wish_list'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(AppLocalizations.of(context).translate('no')),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text(AppLocalizations.of(context).translate('yes')),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                ),
              ],
            ),
          );
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart)
          Provider.of<CartProvider>(context, listen: false)
              .removeItem(_cart.id);
        else {
          Provider.of<CartProvider>(context, listen: false)
              .moveToWishList(_cart.id)
              .then((value) {
            if (value) {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context).translate('added_wish_list'),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            } else {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)
                        .translate('something_went_wrong'),
                  ),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          });
        }
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
              ),
            ),
            title: Text(_cart.title ?? ""),
            subtitle: Text('Total: ${_cart.price}'),
            trailing: Text('${_cart.quantity} x'),
          ),
        ),
      ),
    );
  }
}
