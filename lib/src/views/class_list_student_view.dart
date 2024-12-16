import 'package:flutter/material.dart';
import 'package:it_4788/src/services/class_service.dart';
import 'package:it_4788/src/ui/components/footer.dart';
import 'package:it_4788/src/ui/components/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassListStudentView extends StatefulWidget {
  const ClassListStudentView({Key? key}) : super(key: key);

  @override
  _ClassListStudentViewState createState() => _ClassListStudentViewState();
}

class _ClassListStudentViewState extends State<ClassListStudentView> {
  String? role_name;
  String? role;
  String? name;
  String? id;
  String? token;
  int currentIndex = 0;
  bool _isStudentListActive = true;
  TextEditingController _searchController = TextEditingController();
  Map<String, String> _students = {}; // Map to store student ID and name
  List<bool> _attendanceStatus = [];
  DateTime _selectedDate = DateTime.now();
  String classId = '000087';
  List<String> _notes = ["", "", "", ""];
  final ClassService _classService = ClassService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();  // Retrieve all keys

// Print all keys and their values
    for (var key in keys) {
      print('$key: ${prefs.get(key)}');
    }
    setState(() {
      role_name = (prefs.getString('role') == "STUDENT") ? 'Sinh viên' : 'Giảng viên';
      token = prefs.getString('token');
      role = prefs.getString('role');
      name = prefs.getString('name');
      id = prefs.getString('userId');
    });

    print('Role: $role');
    print('Token: $token');
    print('Name: $name');
    print('ID: $id');

    // Now make the API call
    if (role != null && id != null) {
      Map<String, String> studentsMap = await _classService.getStudentsOfClass(
        token: token!,
        role: role!,
        accountId: id!,
        classId: classId,
      );
      setState(() {
        _students = studentsMap; // Update _students with the fetched map
        _attendanceStatus = List<bool>.filled(_students.length, false);
      });
    }
  }

  void _toggleView(bool isStudentListActive) {
    setState(() {
      _isStudentListActive = isStudentListActive;
    });
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveAttendance() {
    // Code to save attendance data
    print("Attendance submitted for the date: $_selectedDate");
  }

  void _filterStudents(String query) {
    setState(() {
      if (query.isEmpty) {
        // Reset to all students if query is empty
      } else {
        _students = Map.fromEntries(
            _students.entries.where((entry) =>
                entry.value.toLowerCase().contains(query.toLowerCase()))
        );
      }
    });
  }

  Widget _buildStudentList() {
    return ListView.builder(
      itemCount: _students.length,
      itemBuilder: (context, index) {
        String studentId = _students.keys.elementAt(index);
        String studentName = _students[studentId]!;

        return ListTile(
          leading: const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey,
            child: Icon(Icons.circle_outlined, color: Color(0xFFFF5E5E), size: 20),
          ),
          title: Row(
            children: [
              // Make the student name take up equal space
              Expanded(
                child: Text(
                  studentName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              // Make the student ID take up equal space
              Expanded(
                child: Text(
                  studentId,
                  textAlign: TextAlign.end,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF5E5E)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildAttendanceView() {
    return Column(
      children: [
        // Date Picker Row
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              const Text(
                'Chọn ngày: ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF5E5E)
                ),
                onPressed: _selectDate,
                child: Text(
                  "${_selectedDate.toLocal()}".split(' ')[0],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        // Attendance List
        Expanded(
          child: ListView.builder(
            itemCount: _students.length, // Dynamically get the length of students
            itemBuilder: (context, index) {
              String studentId = _students.keys.elementAt(index);
              String studentName = _students[studentId]!;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Student Name Column
                    Expanded(
                      child: Text(
                        studentName, // Student name
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Attendance Checkbox Column
                    Checkbox(
                      value: _attendanceStatus[index], // Track attendance state
                      onChanged: (bool? value) {
                        setState(() {
                          _attendanceStatus[index] = value ?? false;
                        });
                      },
                    ),
                    // Notes Column
                    Expanded(
                      child: TextField(
                        onChanged: (note) {
                          setState(() {
                            _notes[index] = note; // Update notes for each student
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Ghi chú',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Submit Button (Nộp)
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5E5E)
            ),
            onPressed: _saveAttendance, // Save the current attendance state
            child: const Text(
              'Nộp',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Header(
          role: role_name,
          name: name,
        ),
      ),
      body: Column(
        children: [
          // Class Information Display
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${"IT4788"} - ${"Phát triển ứng dụng đa nền tảng"}',
                  style: TextStyle(
                    color: Color(0xFFFF5E5E),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Toggle Buttons for "Danh sách sinh viên" and "Điểm danh"
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // "Danh sách sinh viên" Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _toggleView(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isStudentListActive
                          ? const Color(0xFFFF5E5E)
                          : Colors.grey[300],
                    ),
                    child: Text(
                      'Danh sách sinh viên',
                      style: TextStyle(
                        color: _isStudentListActive
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // "Điểm danh" Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _toggleView(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_isStudentListActive
                          ? const Color(0xFFFF5E5E)
                          : Colors.grey[300],
                    ),
                    child: Text(
                      'Điểm danh',
                      style: TextStyle(
                        color: !_isStudentListActive
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Search Bar for "Danh sách sinh viên"
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Tìm kiếm sinh viên',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _filterStudents(_searchController.text),
                ),
              ),
            ),
          ),
          // Display the content based on the selected tab
          Expanded(
            child: _isStudentListActive
                ? _buildStudentList()
                : _buildAttendanceView(),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
      ),
    );
  }
}