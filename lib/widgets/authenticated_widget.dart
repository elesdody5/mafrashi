import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/auth.dart';
import 'package:mafrashi/screens/auth_screen.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

/*
* this widget opens only if user is logged in else show error message
* */
class AuthenticatedWidget extends StatelessWidget {
  final Widget child;
  final Function onTap;

  AuthenticatedWidget({this.child, this.onTap});

  void _showAuthenticationAlert(BuildContext context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: AppLocalizations.of(context).translate('please_login'),
      desc: AppLocalizations.of(context).translate("cant_open"),
      style: AlertStyle(isCloseButton: true),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('login'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pushNamed(context, AuthScreen.routeName),
          width: 120,
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    final isAuthenticated =
        Provider.of<Auth>(context, listen: false).isAuthenticated;
    return InkWell(
      child: child,
      onTap: () =>
          isAuthenticated ? onTap() : _showAuthenticationAlert(context),
    );
  }
}
