import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/orders.dart';
import 'package:mafrashi/screens/auth_screen.dart';
import 'package:mafrashi/screens/tabs_screen.dart';
import 'package:mafrashi/widgets/form_text_field.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ShippingAddress extends StatefulWidget {
  Function moveNext;
  Function movePrevious;

  ShippingAddress(this.moveNext, this.movePrevious);

  @override
  _ShippingAddressState createState() {
    return _ShippingAddressState();
  }
}

class _ShippingAddressState extends State<ShippingAddress> {
  String _currentCountry;
  Map<String, String> _shippingAddressForm = {
    'first_name': '',
    'last_name': '',
    'email': '',
    'street_address': '',
    'city': '',
    'country': '',
    'state': '',
    'postal_code': '',
    'phone': ''
  };

  final GlobalKey<FormState> _shippingAddressKey = GlobalKey();

  bool validate() {
    return _shippingAddressKey.currentState.validate();
  }

  void _showAlert(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: AppLocalizations.of(context).translate('something_went_wrong'),
      desc: AppLocalizations.of(context).translate("please_enter_fields"),
      style: AlertStyle(isCloseButton: false),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('close'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  Future<bool> _save() async {
    final ProgressDialog pr = ProgressDialog(context);
    await pr.show();
    if (!validate()) {
      pr.hide();
      return false;
    }
    _shippingAddressKey.currentState.save();
    final provider = Provider.of<Orders>(context, listen: false);
    final result = await provider.saveShippingAddress(_shippingAddressForm);
    if (result) {
      pr.hide();
      widget.moveNext();
    } else {
      _showAlert(context);
    }
    return true;
  }

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
            Navigator.pushReplacementNamed(context, TabsScreen.routeName);
          },
          width: 120,
        )
      ],
    ).show();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _order() async {
    final ProgressDialog pr = ProgressDialog(
      context,
    );
    await pr.show();
    _shippingAddressKey.currentState.save();
    bool saveShipping = await Provider.of<Orders>(context, listen: false)
        .saveShippingAddress(_shippingAddressForm);
    if (saveShipping) {
      bool result =
          await Provider.of<Orders>(context, listen: false).addOrder();
      print(result);
      pr.hide();
      if (result) {
        _showSuccessfully();
      } else {
        pr.hide();

        _showErrorDialog(
            AppLocalizations.of(context).translate('something_went_wrong'));
      }
    } else {
      pr.hide();

      _showErrorDialog(
          AppLocalizations.of(context).translate('something_went_wrong'));
    }
  }

  Widget _buildCountryDropDown(List<String> listItem) {
    return FormField<String>(builder: (FormFieldState<String> state) {
      return InputDecorator(
        decoration: InputDecoration(
            border:
                UnderlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text(AppLocalizations.of(context).translate('country')),
            isDense: true,
            value: _currentCountry,
            onChanged: (newValue) {
              setState(() {
                _currentCountry = newValue;
                _shippingAddressForm['country'] = newValue;
              });
            },
            items: listItem.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppLocalizations.of(context).translate('shipping_address'),
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Form(
          key: _shippingAddressKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              FormTextField(
                hint: AppLocalizations.of(context).translate('first_name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate('please_enter_first_name');
                  }
                },
                save: (value) => _shippingAddressForm['first_name'] = value,
              ),
              FormTextField(
                hint: AppLocalizations.of(context).translate('last_name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate('please_enter_last_name');
                  }
                },
                save: (value) => _shippingAddressForm['last_name'] = value,
              ),
              FormTextField(
                hint: "E-mail",
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                },
                save: (value) {
                  _shippingAddressForm['email'] = value;
                },
              ),
              FormTextField(
                hint: AppLocalizations.of(context).translate('street_address'),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate('please_enter_street');
                  }
                },
                save: (value) {
                  _shippingAddressForm['street_address'] = value;
                },
              ),
              FormTextField(
                hint: AppLocalizations.of(context).translate('city'),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context)
                            .translate('please_enter') +
                        AppLocalizations.of(context).translate('city');
                  }
                },
                save: (value) {
                  _shippingAddressForm['city'] = value;
                },
              ),
              FutureBuilder(
                future:
                    Provider.of<Orders>(context, listen: false).getCountries(),
                builder: (context, snapShot) {
                  if (snapShot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Consumer<Orders>(
                      builder: (_, provider, child) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: _buildCountryDropDown(provider.countries),
                        );
                      },
                    );
                  }
                },
              ),
              FormTextField(
                hint: AppLocalizations.of(context).translate('state'),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context)
                            .translate('please_enter') +
                        AppLocalizations.of(context).translate('state');
                  }
                },
                save: (value) {
                  _shippingAddressForm['state'] = value;
                },
              ),
              FormTextField(
                hint: AppLocalizations.of(context).translate('postal_code'),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context)
                            .translate('please_enter') +
                        AppLocalizations.of(context).translate('postal_code');
                  }
                },
                save: (value) {
                  _shippingAddressForm['postal_code'] = value;
                },
              ),
              FormTextField(
                hint: AppLocalizations.of(context).translate('phone_number'),
                validator: (value) => validateMobile(value, context),
                save: (value) {
                  _shippingAddressForm['phone'] = value;
                },
              ),
            ],
          ),
        ),
        RadioListTile(
          selected: true,
          groupValue: true,
          title: Text(
            "Cash on Delivery",
            style: TextStyle(color: Theme.of(context).accentColor),
          ),
          value: true,
        ),
        FlatButton(
            onPressed: () => widget.movePrevious(),
            child: Row(children: [
              Icon(
                Icons.arrow_back,
                color: Colors.blue,
              ),
              Text(
                AppLocalizations.of(context).translate('previous'),
                style: TextStyle(color: Colors.blue),
              ),
            ])),
        CupertinoButton(
          child: Text(AppLocalizations.of(context).translate('order')),
          color: Colors.green,
          onPressed: _order,
        ),
      ],
    );
  }
}
