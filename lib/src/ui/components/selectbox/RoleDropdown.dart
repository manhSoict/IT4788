import 'package:flutter/material.dart';

class RoleDropdown extends StatefulWidget {
  @override
  _RoleDropdownState createState() => _RoleDropdownState();
}

class _RoleDropdownState extends State<RoleDropdown> {
  String selectedRole = 'Giảng viên';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButton<String>(
        value: selectedRole,
        isExpanded: true,
        dropdownColor: Colors.red,
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        underline: SizedBox(),
        style: TextStyle(color: Colors.white),
        onChanged: (String? newValue) {
          setState(() {
            selectedRole = newValue!;
          });
        },
        items: ['Giảng viên', 'Sinh viên']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
