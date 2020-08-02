import 'package:flutter/material.dart';
import 'package:mafrashi/screens/auth_screen.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isAuthenticated =
        Provider.of<Auth>(context, listen: false).isAuthenticated;

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friend!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //   CustomRoute(
              //     builder: (ctx) => OrdersScreen(),
              //   ),
              // );
            },
          ),
          Divider(),
          isAuthenticated
              ? ListTile(
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Logout'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed('/');

                    Provider.of<Auth>(context, listen: false).logout();
                  },
                )
              : ListTile(
                  leading: Icon(Icons.touch_app),
                  title: Text('Login/Register'),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context)
                        .pushReplacementNamed(AuthScreen.routeName);
                  },
                ),
        ],
      ),
    );
  }
}
