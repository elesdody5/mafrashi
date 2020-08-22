import 'package:flutter/material.dart';
import 'package:mafrashi/language/app_loacl.dart';

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
            AppLocalizations.of(context).translate('something_went_wrong'),
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}
