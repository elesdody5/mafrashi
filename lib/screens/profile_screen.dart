import 'package:flutter/material.dart';
import 'package:mafrashi/providers/auth.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    future: Provider.of<Auth>(context, listen: false).fe(),
    builder: (ctx, dataSnapshot) {
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
    return Consumer<Orders>(
    builder: (ctx, orderData, child) =>Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Icon(Icons.account_circle),
        Container(
          decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Colors.black26,
                  offset: new Offset(0.0, 2.0),
                  blurRadius: 25.0,
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32))),
          alignment: Alignment.topCenter,
          child: Column(
            children: <Widget>[
            ],
          ),
        )
      ],
    );
  }
}
