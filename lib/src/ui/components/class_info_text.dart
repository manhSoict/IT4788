import 'package:flutter/material.dart';

class ClassInfoText extends StatelessWidget {
  final String? classId;
  final String? className;
  final TextStyle? textStyle;
  final Color? backgroundColor;

  const ClassInfoText({
    Key? key,
    this.classId,
    this.className,
    this.textStyle,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Full width
      color: backgroundColor, // Solid red background
      padding: const EdgeInsets.all(12.0), // Add padding inside
      child: Text(
        '${classId ?? "Unknown"} - ${className ?? "Unknown"}',
        style: textStyle ??
            const TextStyle(
              color: Color(0xFFFF5E5E),
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }
}
