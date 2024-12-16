import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Add this for file picker
import 'package:intl/intl.dart'; // For formatting the date
import 'package:it_4788/src/ui/components/header2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/exercise_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ui/components/footer.dart'; // For showing toast messages

class CreateExerciseView extends StatefulWidget {
  const CreateExerciseView({Key? key}) : super(key: key);
  @override
  _CreateExerciseViewState createState() => _CreateExerciseViewState();
}

class _CreateExerciseViewState extends State<CreateExerciseView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int currentIndex = 0;

  // Form fields
  String? _token;
  String? _classId;
  String? _title;
  DateTime? _deadline;
  String? _description;
  File? _file;

  bool _loading = false;

  final ExerciseService _exerciseService = ExerciseService();

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  // Load token from SharedPreferences
  Future<void> _initializeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _token = prefs.getString('token');
      _classId = prefs.getString('classId');
    });
  }

  // Function to pick a file
  Future<void> _pickFile() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Or use ImageSource.camera if needed
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
    }
  }

  // Function to submit the form
  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        _loading = true;
      });

      try {
        if (_file != null && _token != null && _classId != null && _title != null && _deadline != null && _description != null) {
          String formattedDeadline = DateFormat('yyyy-MM-ddTHH:mm:ss').format(_deadline!);

          var result = await _exerciseService.createExercise(
            token: _token!,
            classId: _classId!,
            title: _title!,
            deadline: formattedDeadline,
            description: _description!,
            file: _file!,
          );

          if (result['success']) {
            _showMessage(result['message']);
          } else {
            _showMessage(result['message'], isError: true);
          }
        } else {
          _showMessage('Please fill in all fields and select a file', isError: true);
        }
      } catch (e) {
        _showMessage('Failed to create exercise. Please try again.', isError: true);
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
        child: const Header2(title: 'Tạo bài tập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) => _title = value,
                validator: (value) => value!.isEmpty ? 'Title is required' : null,
              ),

              TextFormField(
                decoration: InputDecoration(labelText: 'Deadline'),
                readOnly: true,
                controller: TextEditingController(
                  text: _deadline != null ? DateFormat('yyyy-MM-dd').format(_deadline!) : '',
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _deadline ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null && pickedDate != _deadline) {
                    setState(() {
                      _deadline = pickedDate;
                    });
                  }
                },
                validator: (value) => _deadline == null ? 'Deadline is required' : null,
              ),

              // Description field
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value,
                validator: (value) => value!.isEmpty ? 'Description is required' : null,
              ),

              // File picker
              GestureDetector(
                onTap: _pickFile,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF5E5E),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        _file != null ? 'File Selected: ${_file!.path.split('/').last}' : 'Choose a File',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _loading ? null : _submitForm,
                child: _loading ? CircularProgressIndicator() : Text('Create Exercise'),
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
