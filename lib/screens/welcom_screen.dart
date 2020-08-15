import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/change_language_provider.dart';
import 'package:mafrashi/screens/auth_screen.dart';
import 'package:mafrashi/screens/tabs_screen.dart';
import 'package:mafrashi/widgets/dialog_style.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class WelcomePage extends StatelessWidget {
  static const routeName = '/welcome';

  void _showDialogChangeLanguage(BuildContext context) {
    Alert(
      context: context,
      style: alertStyle,
      title: AppLocalizations.of(context).translate('choose_language'),
      desc: "",
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('english'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Provider.of<AppLanguage>(context, listen: false)
                .changeLanguage(Locale("en"));
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, WelcomePage.routeName);
          },
        ),
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('arabic'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Provider.of<AppLanguage>(context, listen: false)
                .changeLanguage(Locale("ar"));

            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, WelcomePage.routeName);
          },
        )
      ],
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context).translate('welcome'),
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32, bottom: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 250,
                  child: FlatButton(
                    child: Text(
                        AppLocalizations.of(context).translate('sign_up'),
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, AuthScreen.routeName);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 0, bottom: 16),
                  decoration: BoxDecoration(
                    // color: Colors.green,
                    border: Border.all(color: Theme.of(context).primaryColor),
                    // shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  width: 250,
                  child: FlatButton(
                    child: Text(AppLocalizations.of(context).translate('skip'),
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, TabsScreen.routeName);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate('language'),
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    FlatButton(
                      onPressed: () => _showDialogChangeLanguage(context),
                      child: Text(
                        AppLocalizations.of(context).translate('lan'),
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
