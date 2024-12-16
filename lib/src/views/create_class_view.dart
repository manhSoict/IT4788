import 'package:flutter/material.dart';
import 'package:it_4788/src/ui/components/footer.dart';
import 'package:it_4788/src/ui/components/header2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/class_service.dart';

class CreateClassView extends StatefulWidget {
  const CreateClassView({super.key});

  @override
  State<CreateClassView> createState() => _CreateClassViewState();
}

class _CreateClassViewState extends State<CreateClassView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ClassService _classService = ClassService();

  int currentIndex = 0;

  // Form fields
  String? _classId;
  String? _className;
  String? _classType;
  DateTime? _startDate;
  DateTime? _endDate;
  int? _maxStudents;

  String? _token;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _initializeToken();
  }

  Future<void> _initializeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() => _token = prefs.getString('token'));
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() => _loading = true);

      try {
        // Ensure that the parameters are passed correctly to the createClass method
        if (_token != null && _classId != null && _className != null && _classType != null &&
            _startDate != null && _endDate != null && _maxStudents != null) {
          await _classService.createClass(
            token: _token!,
            classId: _classId!,
            className: _className!,
            classType: _classType!,
            startDate: _startDate!.toIso8601String(),
            endDate: _endDate!.toIso8601String(),
            maxStudentAmount: _maxStudents!,
          );

          _showMessage('Class created successfully!');
        } else {
          _showMessage('Please fill all the required fields.', isError: true);
        }
      } catch (e) {
        _showMessage('Failed to create class. Try again.', isError: true);
      } finally {
        setState(() => _loading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền sáng
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: const Header2(title: 'Tạo lớp'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildForm(),
            ),
          ),
          Footer(currentIndex: currentIndex),
        ],
      ),
    );
  }

  Widget _buildForm() => Form(
    key: _formKey,
    child: ListView(
      children: [
        _buildTextField(
          label: 'Class ID',
          onSaved: (value) => _classId = value,
          validator: (value) => value!.isEmpty ? 'Class ID is required' : null,
        ),
        _buildTextField(
          label: 'Class Name',
          onSaved: (value) => _className = value,
          validator: (value) => value!.isEmpty ? 'Class Name is required' : null,
        ),
        _buildDropdownField(),
        _buildDatePickerField('Start Date', _startDate, () => _selectDate(true)),
        _buildDatePickerField('End Date', _endDate, () => _selectDate(false)),
        _buildTextField(
          label: 'Max Students',
          keyboardType: TextInputType.number,
          onSaved: (value) => _maxStudents = int.tryParse(value ?? '0'),
          validator: (value) => (int.tryParse(value ?? '') ?? 0) > 0
              ? null
              : 'Max students must be greater than 0',
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Create Class'),
        ),
      ],
    ),
  );

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    FormFieldSetter<String>? onSaved,
    FormFieldValidator<String>? validator,
  }) => TextFormField(
    decoration: InputDecoration(labelText: label),
    keyboardType: keyboardType,
    onSaved: onSaved,
    validator: validator,
  );

  Widget _buildDropdownField() => DropdownButtonFormField<String>(
    decoration: const InputDecoration(labelText: 'Class Type'),
    items: const [
      DropdownMenuItem(value: 'LT', child: Text('LT')),
      DropdownMenuItem(value: 'BT', child: Text('BT')),
      DropdownMenuItem(value: 'LT_BT', child: Text('LT & BT')),
    ],
    onChanged: (value) => setState(() => _classType = value),
    validator: (value) => value == null ? 'Please select a class type' : null,
  );

  Widget _buildDatePickerField(String label, DateTime? date, VoidCallback onTap) => ListTile(
    title: Text(label),
    subtitle: Text(date != null ? date.toLocal().toString().split(' ')[0] : 'Not selected'),
    trailing: const Icon(Icons.calendar_today),
    onTap: onTap,
  );
}
