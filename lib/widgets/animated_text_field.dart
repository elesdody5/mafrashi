import 'package:flutter/material.dart';
import 'package:mafrashi/screens/auth_screen.dart';

class AnimatedTextField extends StatelessWidget {
  const AnimatedTextField(
      {@required AuthMode authMode,
      @required Animation<double> opacityAnimation,
      @required Animation<Offset> slideAnimation,
      @required Widget child})
      : _authMode = authMode,
        _opacityAnimation = opacityAnimation,
        _slideAnimation = slideAnimation,
        _child = child;

  final AuthMode _authMode;
  final Animation<double> _opacityAnimation;
  final Animation<Offset> _slideAnimation;
  final Widget _child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      constraints: BoxConstraints(
        minHeight: _authMode == AuthMode.Signup ? 60 : 0,
        maxHeight: _authMode == AuthMode.Signup ? 120 : 0,
      ),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(position: _slideAnimation, child: _child),
      ),
    );
  }
}
