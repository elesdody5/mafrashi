import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/screens/tabs_screen.dart';
import 'package:mafrashi/widgets/animated_text_field.dart';
import 'package:mafrashi/widgets/dialog_style.dart';
import 'package:mafrashi/widgets/form_text_field.dart';
import 'package:mafrashi/widgets/radio_group_button.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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
  final _key = GlobalKey<ScaffoldState>();

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
  final _dateController = TextEditingController();
  final _emailController = TextEditingController();
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

  void _showSignUpSuccessfully() {
    Alert(
      context: context,
      type: AlertType.success,
      title: AppLocalizations.of(context).translate('sign_up_successfully'),
      style: AlertStyle(isCloseButton: false),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('continue'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
            _switchAuthMode();
          },
          width: 120,
        )
      ],
    ).show();
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
        bool result = await Provider.of<Auth>(context, listen: false).login(
          _authData['email'],
          _authData['password'],
        );
        if (result)
          Navigator.pushReplacementNamed(context, TabsScreen.routeName);
      } else {
        // Sign user up
        bool result = await Provider.of<Auth>(context, listen: false).signUp(
            _authData['first_name'],
            _authData['last_name'],
            _authData['email'],
            _authData['gender'],
            _authData['password'],
            _authData['password'],
            _authData['phone'],
            _authData['date_of_birth']);
        if (result) _showSignUpSuccessfully();
      }
    } on HttpException {
      var errorMessage = 'Invalid Email or Password';
      _showErrorDialog(errorMessage);
    } catch (error) {
      print(error);
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

  void _showPicker() async {
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1980, 1, 1),
        lastDate: DateTime.now());
    if (dateTime != null) {
      String date = DateFormat('yyyy-MM-dd').format(dateTime);
      _authData['date_of_birth'] = date;
      _dateController.text = date;
    }
  }

  Future<void> _forgetPassword() async {
    setState(() {
      _isLoading = true;
    });
    String message = await Provider.of<Auth>(context, listen: false)
        .forgetPassword(_emailController.text);
    _key.currentState.showSnackBar(SnackBar(
      content: Text(message),
      elevation: 2,
      backgroundColor: Theme.of(context).primaryColor,
    ));
    setState(() {
      _isLoading = false;
    });
  }

  void _showForgetPasswordDialog() {
    Alert(
        context: context,
        style: alertStyle,
        title: "Forget password",
        content: _buildEmailTextField(),
        buttons: [
          DialogButton(
            child: _isLoading ? CircularProgressIndicator : Text("Submit"),
            onPressed: () {
              Navigator.pop(context);
              _forgetPassword();
            },
          )
        ]).show();
  }

  Widget _buildEmailTextField() {
    return FormTextField(
      hint: "E-mail",
      controller: _emailController,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
        key: _key,
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
                          AppLocalizations.of(context).translate('log_in'),
                          style: TextStyle(
                            fontSize: 20,
                            color: _authMode == AuthMode.Login
                                ? Theme.of(context).primaryColor
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
                          AppLocalizations.of(context).translate('sign_up'),
                          style: TextStyle(
                            fontSize: 20,
                            color: _authMode == AuthMode.Signup
                                ? Theme.of(context).primaryColor
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
                    AppLocalizations.of(context).translate('welcome_message'),
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        AnimatedInputField(
                          authMode: _authMode,
                          opacityAnimation: _opacityAnimation,
                          slideAnimation: _slideAnimation,
                          child: FormTextField(
                            hint: AppLocalizations.of(context)
                                .translate('first_name'),
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value.isEmpty) {
                                      return AppLocalizations.of(context)
                                          .translate('please_enter_first_name');
                                    }
                                  }
                                : null,
                            save: (value) => _authData['first_name'] = value,
                          ),
                        ),
                        AnimatedInputField(
                          authMode: _authMode,
                          opacityAnimation: _opacityAnimation,
                          slideAnimation: _slideAnimation,
                          child: FormTextField(
                            hint: AppLocalizations.of(context)
                                .translate('last_name'),
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value.isEmpty) {
                                      return AppLocalizations.of(context)
                                          .translate('please_enter_last_name');
                                    }
                                  }
                                : null,
                            save: (value) => _authData['last_name'] = value,
                          ),
                        ),
                        _buildEmailTextField(),
                        FormTextField(
                          obscure: true,
                          hint: AppLocalizations.of(context)
                              .translate('password'),
                          controller: _passwordController,
                          validator: _authMode == AuthMode.Signup
                              ? (value) {
                                  if (value.isEmpty || value.length < 5) {
                                    return AppLocalizations.of(context)
                                        .translate('short_password');
                                  }
                                }
                              : null,
                          save: (value) {
                            _authData['password'] = value;
                          },
                        ),
                        AnimatedInputField(
                          authMode: _authMode,
                          opacityAnimation: _opacityAnimation,
                          slideAnimation: _slideAnimation,
                          child: FormTextField(
                            obscure: true,
                            hint: AppLocalizations.of(context)
                                .translate('confirm_password'),
                            validator: _authMode == AuthMode.Signup
                                ? (value) {
                                    if (value != _passwordController.text) {
                                      return AppLocalizations.of(context)
                                          .translate('password_not_match');
                                    }
                                  }
                                : null,
                          ),
                        ),
                        AnimatedInputField(
                          authMode: _authMode,
                          opacityAnimation: _opacityAnimation,
                          slideAnimation: _slideAnimation,
                          child: FormTextField(
                            hint: AppLocalizations.of(context)
                                .translate('phone_number'),
                            validator: _authMode == AuthMode.Signup
                                ? (value) => validateMobile(value, context)
                                : null,
                            save: (value) {
                              _authData['phone'] = value;
                            },
                          ),
                        ),
                        AnimatedInputField(
                            authMode: _authMode,
                            opacityAnimation: _opacityAnimation,
                            slideAnimation: _slideAnimation,
                            child: RadioGroupWidget(_character, _authData)),
                        InkWell(
                          onTap: () => _showPicker(),
                          child: AnimatedInputField(
                              authMode: _authMode,
                              opacityAnimation: _opacityAnimation,
                              slideAnimation: _slideAnimation,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    left: 16, right: 16, top: 32, bottom: 8),
                                child: TextFormField(
                                  enabled: false,
                                  controller: _dateController,
                                  style: TextStyle(fontSize: 18),
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    hintText: AppLocalizations.of(context)
                                        .translate('date_of_birth'),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  validator: _authMode == AuthMode.Signup
                                      ? (value) {
                                          if (value.isEmpty) {
                                            return AppLocalizations.of(context)
                                                .translate(
                                                    'enter_date_of_birth');
                                          }
                                        }
                                      : null,
//
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Visibility(
                          visible: _authMode == AuthMode.Login,
                          child: FlatButton(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate('forget_password'),
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            onPressed: _showForgetPasswordDialog,
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                                color: Theme.of(context).primaryColor,
                                shape: BoxShape.circle),
                            child: _isLoading
                                ? CircularProgressIndicator()
                                : IconButton(
                                    color: Colors.white,
                                    onPressed: _submit,
                                    icon: Icon(Icons.arrow_forward),
                                  ),
                          )),
                    ]),
              ],
            ),
          ),
        ));
  }
}

String validateMobile(String value, BuildContext context) {
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return AppLocalizations.of(context).translate('enter_phone');
  } else if (!regExp.hasMatch(value)) {
    return AppLocalizations.of(context).translate('enter_valid_phone');
  }
  return null;
}
