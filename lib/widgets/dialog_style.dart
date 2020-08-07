import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//this for dialog style
var alertStyle = AlertStyle(
  animationType: AnimationType.fromRight,
  isCloseButton: true,
  isOverlayTapDismiss: true,
  descStyle: TextStyle(fontWeight: FontWeight.bold),
  animationDuration: Duration(milliseconds: 400),
  alertBorder: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20),
    side: BorderSide(
      color: Colors.black54,
    ),
  ),
  titleStyle: TextStyle(
    fontSize: 18,
    color: Colors.grey[700],
  ),
  //backgroundColor: PrimaryLightColor
);
