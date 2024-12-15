import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? leftIcon;
  final IconData? rightIcon;
  final bool obscureText;
  final VoidCallback? onRightIconPressed;

  const CustomInput({
    Key? key,
    required this.controller,
    required this.hintText,
    this.leftIcon,
    this.rightIcon,
    this.obscureText = false,
    this.onRightIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon:
            leftIcon != null ? Icon(leftIcon, color: Colors.white) : null,
        suffixIcon: rightIcon != null
            ? IconButton(
                icon: Icon(rightIcon, color: Colors.white),
                onPressed: onRightIconPressed,
              )
            : null,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyle(color: Colors.white),
    );
  }
}
