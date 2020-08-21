import 'package:flutter/material.dart';

enum SingingCharacter { male, female }

class RadioGroupWidget extends StatefulWidget {
  SingingCharacter _character;
  final _authData;
  RadioGroupWidget(this._character, this._authData);

  @override
  _RadioGroupWidgetState createState() => _RadioGroupWidgetState();
}

class _RadioGroupWidgetState extends State<RadioGroupWidget> {
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Radio(
          value: SingingCharacter.male,
          groupValue: widget._character,
          onChanged: (SingingCharacter value) {
            setState(() {
              widget._character = value;
              widget._authData['gender'] = value;
            });
          },
        ),
        const Text('Male'),
        Radio(
          value: SingingCharacter.female,
          groupValue: widget._character,
          onChanged: (SingingCharacter value) {
            setState(() {
              widget._character = value;
              widget._authData['gender'] = value;
            });
          },
        ),
        const Text('Female'),
      ],
    );
  }
}
