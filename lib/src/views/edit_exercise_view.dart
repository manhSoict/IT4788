import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:it_4788/src/ui/components/header2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/exercise_service.dart';
import 'package:fluttertoast/fluttertoast.dart'; // For showing toast messages

class EditExerciseView extends StatefulWidget {

  const EditExerciseView({Key? key}) : super(key: key);
  @override
  _CreateExerciseViewState createState() => _CreateExerciseViewState();
}

class _CreateExerciseViewState extends State<EditExerciseView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Form fields
  String? _token;
  String? _classId;
  DateTime? _deadline;
  String? _description;
  File? _file;
  int? _exerciseId;

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
      _exerciseId = prefs.getInt('exerciseId');
    });
  }

  // Function to pick a file
  Future<void> _pickFile() async {
    // Use file_picker to pick any file, specifying PDF or other types if needed
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (result != null) {
      // Get the picked file
      PlatformFile file = result.files.first;

      setState(() {
        _file = File(file.path!);  // Ensure that file.path is non-null
      });

      print('File picked: ${file.name}, path: ${file.path}');
    } else {
      // User canceled the picker
      print("No file selected");
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
        if (_file != null && _token != null && _classId != null && _deadline != null && _description != null) {
          String formattedDeadline = DateFormat('yyyy-MM-ddTHH:mm:ss').format(_deadline!);

          var result = await _exerciseService.editExercise(
            token: _token!,
            deadline: formattedDeadline,
            description: _description!,
            file: _file!,
            assignmentId: _exerciseId!
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
        child: const Header2(title: 'Sửa bài tập'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [

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
                child: _loading ? CircularProgressIndicator() : Text('Edit Exercise'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
