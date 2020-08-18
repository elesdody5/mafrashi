import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: 1,
          child: Image.asset('assets/images/icon.png'),
        ),
      ),
    );
  }
}
