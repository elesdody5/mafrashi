import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mafrashi/language/app_loacl.dart';
import 'package:mafrashi/providers/change_language_provider.dart';
import 'package:mafrashi/providers/profile.dart';
import 'package:mafrashi/screens/auth_screen.dart';
import 'package:mafrashi/screens/welcom_screen.dart';
import 'package:mafrashi/widgets/dialog_style.dart';
import 'package:mafrashi/widgets/form_text_field.dart';
import 'package:mafrashi/widgets/radio_group_button.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _edit = false;
  bool _isLoading = false;
  SingingCharacter _character = SingingCharacter.male;

  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  final _dateController = TextEditingController();
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'first_name': '',
    'last_name': '',
    'phone': '',
    'gender': '',
    'date_of_birth': ''
  };

  void _showSignUpSuccessfully() {
    Alert(
      context: context,
      type: AlertType.success,
      title: AppLocalizations.of(context).translate('updated_successfully'),
      style: AlertStyle(isCloseButton: false),
      buttons: [
        DialogButton(
          child: Text(
            AppLocalizations.of(context).translate('continue'),
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
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
      bool result = await Provider.of<ProfileProvider>(context, listen: false)
          .editProfile(
          _authData['first_name'],
          _authData['last_name'],
          _authData['email'],
          _authData['gender'],
          _authData['password'],
          _authData['password'],
          _authData['phone'],
          _authData['date_of_birth']);
      if (result) _showSignUpSuccessfully();
    } catch (error) {
      const errorMessage =
          'Could not edit your profile. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) =>
          AlertDialog(
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

  void _switchEdit() {
    setState(() {
      _edit = true;
    });
  }

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
void _showLogoutDialog(){
  showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context).translate('log_out')),
          content: Text('dialogBody'),
          actions: <Widget>[
            FlatButton(
              child: Text('buttonText'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('profile')),
        actions: <Widget>[
          IconButton(
            icon: Icon(!_edit ? Icons.edit : Icons.save),
            onPressed: !_edit ? _switchEdit : _submit,
          ),
          IconButton(
            icon: Icon(Icons.language),
            onPressed: () => _showDialogChangeLanguage(context),
          )
          ,IconButton(icon: Icon(Icons.exit_to_app),onPressed: ()=>_showLogoutDialog(),)
        ],
      ),
      body: FutureBuilder(
          future: Provider.of<ProfileProvider>(context, listen: false)
              .getUserData(),
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
                return Consumer<ProfileProvider>(
                    builder: (ctx, profile, child) =>
                        ListView(
                          children: <Widget>[
                            Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: <Widget>[
                                    FormTextField(
                                        enable: _edit,
                                        hint: "${profile.user.firstName}",
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return AppLocalizations.of(context)
                                                .translate(
                                                'please_enter_first_name');
                                          }
                                        }),
                                    FormTextField(
                                        enable: _edit,
                                        hint: profile.user.lastName,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return AppLocalizations.of(context)
                                                .translate(
                                                'please_enter_last_name');
                                          }
                                        }),
                                    FormTextField(
                                      enable: _edit,
                                      hint: profile.user.email,
                                      validator: (value) {
                                        if (value.isEmpty ||
                                            !value.contains('@')) {
                                          return 'Invalid email!';
                                        }
                                      },
                                      save: (value) {
                                        _authData['email'] = value;
                                      },
                                    ),
                                    Visibility(
                                      visible: _edit,
                                      child: FormTextField(
                                        hint: AppLocalizations.of(context)
                                            .translate('password'),
                                        controller: _passwordController,
                                        validator: (value) {
                                          if (value.isEmpty ||
                                              value.length < 5) {
                                            return AppLocalizations.of(context)
                                                .translate('short_password');
                                          }
                                        },
                                        save: (value) {
                                          _authData['password'] = value;
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: _edit,
                                      child: FormTextField(
                                          hint: AppLocalizations.of(context)
                                              .translate('confirm_password'),
                                          validator: (value) {
                                            if (value !=
                                                _passwordController.text) {
                                              return AppLocalizations.of(
                                                  context)
                                                  .translate(
                                                  'password_not_match');
                                            }
                                          }),
                                    ),
                                    FormTextField(
                                      hint: profile.user.phone,
                                      validator: (value) =>
                                          validateMobile(value, context),
                                      save: (value) {
                                        _authData['phone'] = value;
                                      },
                                    ),
                                    RadioGroupWidget(_character),
                                    InkWell(
                                      onTap: () => _showPicker(),
                                      child: FormTextField(
                                          enable: _edit,
                                          controller: _dateController,
                                          hint: profile.user.dateOfBirth,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return AppLocalizations.of(
                                                  context)
                                                  .translate(
                                                  'enter_date_of_birth');
                                            }
                                          }),
                                    )
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ));
              }
            }
          }),
    );
  }
}
