import 'package:flutter/material.dart';

class ErrorImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.cloud_off,
            size: 100,
          ),
          Text(
            "Something went wrong please try again later",
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
