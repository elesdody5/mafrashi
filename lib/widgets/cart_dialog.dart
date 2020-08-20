import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/model/product.dart';
import 'package:mafrashi/providers/cart.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CartDialog extends StatefulWidget {
  Product _product;

  CartDialog(this._product);

  @override
  _CartDialogState createState() => _CartDialogState();
}

class _CartDialogState extends State<CartDialog> {
  bool _isLoading = false;
  ProductColor _currentColor;

  ProductVariant _currentVariant;
  ProductSize _currentSize;
  int _quantity = 1;

  Widget _buildVariantsDropDown(
    List<ProductVariant> listItem,
  ) {
    return FormField<String>(builder: (FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
            border:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ProductVariant>(
            isExpanded: true,
            hint: Text(AppLocalizations.of(context).translate('variants')),
            isDense: true,
            value: _currentVariant,
            onChanged: (newValue) {
              setState(() {
                _currentVariant = newValue;
              });
            },
            items: listItem.map((ProductVariant value) {
              return DropdownMenuItem<ProductVariant>(
                value: value,
                child: FittedBox(fit: BoxFit.fill, child: Text(value.name)),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  Widget _buildColorDropDown(
    List<ProductColor> listItem,
  ) {
    return FormField<String>(builder: (FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
            border:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ProductColor>(
            hint: Text(AppLocalizations.of(context).translate('color')),
            isDense: true,
            value: _currentColor,
            onChanged: (newValue) {
              setState(() {
                _currentColor = newValue;
              });
            },
            items: listItem.map((ProductColor value) {
              return DropdownMenuItem<ProductColor>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  Widget _buildSizeDropDown(
    List<ProductSize> listItem,
  ) {
    return FormField<String>(builder: (FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
            border:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ProductSize>(
            hint: Text(AppLocalizations.of(context).translate('size')),
            isDense: true,
            value: _currentSize,
            onChanged: (newValue) {
              setState(() {
                _currentSize = newValue;
              });
            },
            items: listItem.map((ProductSize value) {
              return DropdownMenuItem<ProductSize>(
                value: value,
                child: Text(value.name),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  void _showAddedSuccessfully(BuildContext context) {
    Alert(
        context: context,
        type: AlertType.success,
        title: AppLocalizations.of(context).translate('added_cart'),
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
        ]).show();
  }

  void _showErrorAlert() {
    Alert(
        context: context,
        type: AlertType.error,
        title: 'something_went_wrong',
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
        ]).show();
  }

  Future<void> _submit(BuildContext context) async {
    if (!_validate())
      return;
    else {
      final ProgressDialog pr = ProgressDialog(context);
      await pr.show();
      final provider = Provider.of<CartProvider>(context, listen: false);
      bool result = await provider.addItem(widget._product.id, _quantity,
          _currentColor.id, _currentSize.id, _currentVariant.id);
      await pr.hide();
      // remove current dialog
      Navigator.pop(context);

      result ? _showAddedSuccessfully(context) : _showErrorAlert();
    }
  }

  bool _validate() {
    return _currentVariant != null &&
        _currentSize != null &&
        _currentColor != null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context).translate('add_to_cart')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildVariantsDropDown(widget._product.varints),
          SizedBox(
            height: 10,
          ),
          _buildColorDropDown(widget._product.colors),
          SizedBox(
            height: 10,
          ),
          _buildSizeDropDown(widget._product.sizes),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(AppLocalizations.of(context).translate('quantity')),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      splashColor: Colors.white60, // inkwell color
                      child: SizedBox(
                          width: 56, height: 56, child: Icon(Icons.remove)),
                      onTap: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                    ),
                  ),
                ),
                Text(_quantity.toString()),
                ClipOval(
                  child: Material(
                    color: Colors.white, // button color
                    child: InkWell(
                      splashColor: Colors.white60, // inkwell color
                      child: SizedBox(
                          width: 56, height: 56, child: Icon(Icons.add)),
                      onTap: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                    ),
                  ),
                )
              ],
            ),
          ])
        ],
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(AppLocalizations.of(context).translate('cancel')),
          onPressed: () {
            Navigator.of(context).pop(); // Dismiss alert dialog
          },
        ),
        FlatButton(
            child: Text(AppLocalizations.of(context).translate('add_to_cart')),
            onPressed: () => _submit(context)),
      ],
    );
  }
}
