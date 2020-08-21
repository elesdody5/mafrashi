import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/orders.dart';
import 'package:mafrashi/screens/auth_screen.dart';
import 'package:mafrashi/widgets/form_text_field.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BillingAddress extends StatefulWidget {
  Function moveNext;

  BillingAddress(this.moveNext);

  @override
  _BillingAddressState createState() {
    return _BillingAddressState();
  }
}

class _BillingAddressState extends State<BillingAddress> {
  String _currentCountry;
  Map<String, String> _billingAddressForm = {
    'company_name': '',
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

  final GlobalKey<FormState> _billingAddressKey = GlobalKey();

  bool validate() {
    return _billingAddressKey.currentState.validate();
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
          onPressed: () => Navigator.of(context).pop(),
          width: 120,
        )
      ],
    ).show();
  }

  Future<bool> _save() async {
    if (!validate()) {
      return false;
    }
    _billingAddressKey.currentState.save();
    final provider = Provider.of<Orders>(context, listen: false);
    provider.saveBillingAddress(_billingAddressForm);
    widget.moveNext();
    return true;
  }

  Widget _buildCountryDropDown(List<String> listItem) {
    print(listItem);
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
                print(newValue);
                _currentCountry = newValue;
                _billingAddressForm['country'] = newValue;
              });
            },
            items: listItem.map((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
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
            AppLocalizations.of(context).translate('billing_address'),
            style: Theme.of(context).textTheme.title,
          ),
        ),
        Form(
          key: _billingAddressKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              FormTextField(
                hint: AppLocalizations.of(context).translate('company_name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate('enter_comany_name');
                  }
                },
                save: (value) => _billingAddressForm['company_name'] = value,
              ),
              FormTextField(
                hint: AppLocalizations.of(context).translate('first_name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate('please_enter_first_name');
                  }
                },
                save: (value) => _billingAddressForm['first_name'] = value,
              ),
              FormTextField(
                hint: AppLocalizations.of(context).translate('last_name'),
                validator: (value) {
                  if (value.isEmpty) {
                    return AppLocalizations.of(context)
                        .translate('please_enter_last_name');
                  }
                },
                save: (value) => _billingAddressForm['last_name'] = value,
              ),
              FormTextField(
                hint: "E-mail",
                validator: (value) {
                  if (value.isEmpty || !value.contains('@')) {
                    return 'Invalid email!';
                  }
                },
                save: (value) {
                  _billingAddressForm['email'] = value;
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
                  _billingAddressForm['street_address'] = value;
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
                  _billingAddressForm['city'] = value;
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
                  _billingAddressForm['state'] = value;
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
                  _billingAddressForm['postal_code'] = value;
                },
              ),
              FormTextField(
                hint: AppLocalizations.of(context).translate('phone_number'),
                validator: (value) => validateMobile(value, context),
                save: (value) {
                  _billingAddressForm['phone'] = value;
                },
              ),
            ],
          ),
        ),
        FlatButton(
            onPressed: _save,
            child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('next'),
                    style: TextStyle(color: Colors.blue),
                  ),
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.blue,
                  )
                ]))
      ],
    );
  }
}
