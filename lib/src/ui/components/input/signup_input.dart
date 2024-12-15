import 'package:flutter/material.dart';

class SignupInput extends StatelessWidget {
  final String labelText;
  final IconData? icon;
  final bool isPassword;

  const SignupInput({
    required this.labelText,
    this.icon,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        suffixIcon: icon != null ? Icon(icon, color: Colors.white) : null,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}