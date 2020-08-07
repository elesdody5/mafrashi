import 'package:flutter/material.dart';
import 'package:mafrashi/providers/auth.dart';
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
      title: "Please Login to continue",
      desc: "Can't open without login ",
      style: AlertStyle(isCloseButton: true),
      buttons: [
        DialogButton(
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
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
      onTap: () => isAuthenticated ? onTap : _showAuthenticationAlert(context),
    );
  }
}
