import 'package:flutter/material.dart';

class AuthTextField extends StatefulWidget {
  const AuthTextField(
      {super.key, required this.onValueSelected, required this.label});

  final void Function(String value) onValueSelected;
  final String label;

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  String? _selectedValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
        color: Colors.white,
      ),
      decoration: InputDecoration(
        labelText: widget.label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: (newValue) {
        if (newValue != null) {
          setState(() {
            _selectedValue = newValue;
          });
          widget.onValueSelected(_selectedValue!);
        }
      },
    );
  }
}
