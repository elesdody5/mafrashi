import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  final Function validator;
  final hint;
  final TextEditingController controller;
  final Function save;
  final enable;
  final obscure;

  FormTextField(
      {this.hint,
      this.validator,
      this.controller,
      this.save,
      this.enable = true,
      this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
      child: TextFormField(
        obscureText: obscure,
        enabled: enable,
        controller: controller,
        style: TextStyle(fontSize: 18),
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: hint,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey)),
        ),
        validator: validator,
        onSaved: save,
      ),
    );
  }
}
