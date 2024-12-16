import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:it_4788/src/ui/components/header2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/class_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ui/components/footer.dart'; // For showing toast messages

class EditClassView extends StatefulWidget {
  const EditClassView({Key? key}) : super(key: key);

  @override
  _EditClassViewState createState() => _EditClassViewState();
}

class _EditClassViewState extends State<EditClassView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int currentIndex = 0;

  // Form fields
  String? _token;
  String? _classId;
  String? _className;
  String? _status;
  DateTime? _startDate;
  DateTime? _endDate;

  bool _loading = false;

  final ClassService _classService = ClassService();

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  // Load token and class ID from SharedPreferences
  Future<void> _initializeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      _classId = prefs.getString('classId');
    });
  }

  // Function to submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _loading = true;
      });

      try {
        if (_token != null && _classId != null && _className != null && _status != null && _startDate != null && _endDate != null) {
          String formattedStartDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(_startDate!);
          String formattedEndDate = DateFormat('yyyy-MM-ddTHH:mm:ss').format(_endDate!);

          var result = await _classService.editClass(
            token: _token!,
            classId: _classId!,
            className: _className!,
            status: _status!,
            startDate: formattedStartDate,
            endDate: formattedEndDate,
          );

          if (result['success']) {
            _showMessage(result['message']);
          } else {
            _showMessage(result['message'], isError: true);
          }
        } else {
          _showMessage('Please fill in all fields', isError: true);
        }
      } catch (e) {
        _showMessage('Failed to edit class. Please try again.', isError: true);
      } finally {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: isError ? Colors.red : Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: const Header2(title: 'Sửa lớp học'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Class Name field
              TextFormField(
                decoration: InputDecoration(labelText: 'Class Name'),
                onSaved: (value) => _className = value,
                validator: (value) => value!.isEmpty ? 'Class name is required' : null,
              ),

              // Status dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Status'),
                value: _status,
                items: ['ACTIVE', 'COMPLETED', 'UPCOMING']
                    .map((status) => DropdownMenuItem(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) => setState(() {
                  _status = value;
                }),
                validator: (value) => value == null ? 'Status is required' : null,
              ),

              // Start Date field
              TextFormField(
                decoration: InputDecoration(labelText: 'Start Date'),
                readOnly: true,
                controller: TextEditingController(
                  text: _startDate != null ? DateFormat('yyyy-MM-dd').format(_startDate!) : '',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _startDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != _startDate) {
                    setState(() {
                      _startDate = pickedDate;
                    });
                  }
                },
                validator: (value) => _startDate == null ? 'Start date is required' : null,
              ),

              // End Date field
              TextFormField(
                decoration: InputDecoration(labelText: 'End Date'),
                readOnly: true,
                controller: TextEditingController(
                  text: _endDate != null ? DateFormat('yyyy-MM-dd').format(_endDate!) : '',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != _endDate) {
                    setState(() {
                      _endDate = pickedDate;
                    });
                  }
                },
                validator: (value) => _endDate == null ? 'End date is required' : null,
              ),

              SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _loading ? null : _submitForm,
                child: _loading ? CircularProgressIndicator() : Text('Edit Class'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
      ),
    );
  }
}
