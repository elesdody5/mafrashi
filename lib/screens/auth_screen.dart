import 'package:flutter/material.dart';
import 'package:mafrashi/widgets/animated_text_field.dart';
import 'package:mafrashi/widgets/form_text_field.dart';
import 'package:mafrashi/widgets/radio_group_button.dart';
import 'package:provider/provider.dart';

import '../model/http_exception.dart';
import '../providers/auth.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatefulWidget {
  static const routeName = '/auth';

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  AuthMode _authMode = AuthMode.Login;

  SingingCharacter _character = SingingCharacter.male;

  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'first_name': '',
    'last_name': '',
    'phone': '',
    'gender': '',
    'date_of_birth': ''
  };

  var _isLoading = false;

  final _passwordController = TextEditingController();

  AnimationController _controller;

  Animation<Offset> _slideAnimation;

  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.fastOutSlowIn,
      ),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    // _heightAnimation.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false).signUp(
            _authData['first_name'],
            _authData['last_name'],
            _authData['email'],
            _authData['gender'],
            _authData['password'],
            _authData['password'],
            _authData['phone'],
            _authData['date_of_birth']);
      }
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  void showPicker() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: null);
    if (dateTime != null) {}
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: _authMode == AuthMode.Signup ? 600 : 420,
          // height: _heightAnimation.value.height,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.Signup ? 320 : 260),
          width: deviceSize.width,
          child: Container(
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
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32))),
            alignment: Alignment.topCenter,
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(16),
                      child: FlatButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 20,
                            color: _authMode == AuthMode.Login
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: FlatButton(
                        onPressed: _switchAuthMode,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 20,
                            color: _authMode == AuthMode.Signup
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, top: 8),
                  child: Text(
                    'Welcome to Mafrashi.',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16, top: 8),
                  child: Text(
                    'Let\'s get started',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        AnimatedTextField(
                          authMode: _authMode,
                          opacityAnimation: _opacityAnimation,
                          slideAnimation: _slideAnimation,
                          child: FormTextField(
                            hint: "First Name",
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter your first name';
                                    }
                                  }
                                : null,
                          ),
                        ),
                        AnimatedTextField(
                          authMode: _authMode,
                          opacityAnimation: _opacityAnimation,
                          slideAnimation: _slideAnimation,
                          child: FormTextField(
                            hint: "Last Name",
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value.isEmpty) {
                                      return 'Please enter your last name';
                                    }
                                  }
                                : null,
                          ),
                        ),
                        FormTextField(
                          hint: "E-mail",
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value.isEmpty || !value.contains('@')) {
                                    return 'Invalid email!';
                                  }
                                }
                              : null,
                          save: (value) {
                            _authData['email'] = value;
                          },
                        ),
                        FormTextField(
                          hint: "Password",
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value.isEmpty || value.length < 5) {
                                    return 'Password is too short!';
                                  }
                                }
                              : null,
                          save: (value) {
                            _authData['password'] = value;
                          },
                        ),
                        AnimatedTextField(
                          authMode: _authMode,
                          opacityAnimation: _opacityAnimation,
                          slideAnimation: _slideAnimation,
                          child: FormTextField(
                            hint: "Confirm Password",
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value != _passwordController.text) {
                                      return 'Passwords do not match!';
                                    }
                                  }
                                : null,
                          ),
                        ),
                        AnimatedTextField(
                          authMode: _authMode,
                          opacityAnimation: _opacityAnimation,
                          slideAnimation: _slideAnimation,
                          child: FormTextField(
                            hint: "Phone Number",
                            validator: _authMode == AuthMode.Signup
                                ? (value) => validateMobile(value)
                                : null,
                            save: (value) {
                              _authData['phone'] = value;
                            },
                          ),
                        ),
                        AnimatedTextField(
                            authMode: _authMode,
                            opacityAnimation: _opacityAnimation,
                            slideAnimation: _slideAnimation,
                            child: RadioGroupWidget(_character)),
                      ],
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                      child: IconButton(
                        color: Colors.white,
                        onPressed: _submit,
                        icon: Icon(Icons.arrow_forward),
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}

String validateMobile(String value) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}
