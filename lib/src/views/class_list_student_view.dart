import 'package:flutter/material.dart';
import 'package:it_4788/src/services/class_service.dart';
import 'package:it_4788/src/services/absence_service.dart'; // Import the absence service
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
  bool _isAttendanceActive = false;
  Map<String, String> _students = {};
  List<bool> _attendanceStatus = [];
  DateTime _selectedDate = DateTime.now();
  String classId = '000087';
  List<String> _notes = ["", "", "", ""];
  final ClassService _classService = ClassService();
  final AbsenceService _absenceService = AbsenceService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    Set<String> keys = prefs.getKeys();

    // Print all keys and their values
    for (var key in keys) {
      print('$key: ${prefs.get(key)}');
    }
    setState(() {
      role_name = (prefs.getString('role') == "STUDENT") ? 'Sinh viên' : 'Giảng viên';
      token = prefs.getString('token');
      role = prefs.getString('role');
      name = prefs.getString('name');
      id = prefs.getString('id');
    });

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

  void _toggleView(int index) {
    setState(() {
      _isStudentListActive = index == 0;
      _isAttendanceActive = index == 1;
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
    print("Attendance submitted for the date: $_selectedDate");
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
              Text(
                studentName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              Text(
                studentId,
                style: const TextStyle(fontWeight: FontWeight.normal, color: Color(0xFFFF5E5E)),
              ),
            ],
          ),
          trailing: const Text(
            'Vắng: 10',
            style: TextStyle(color: Color(0xFFFF5E5E)),
          ),
        );
      },
    );
  }

  Widget _buildAttendanceView() {
    return Column(
      children: [
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
        Expanded(
          child: ListView.builder(
            itemCount: _students.length,
            itemBuilder: (context, index) {
              String studentId = _students.keys.elementAt(index);
              String studentName = _students[studentId]!;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        studentName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Checkbox(
                      value: _attendanceStatus[index],
                      onChanged: (bool? value) {
                        setState(() {
                          _attendanceStatus[index] = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        onChanged: (note) {
                          setState(() {
                            _notes[index] = note;
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
        Padding(
          padding: const EdgeInsets.all(10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5E5E)),
            onPressed: _saveAttendance,
            child: const Text(
              'Nộp',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Header(role: role_name, name: name),
      ),
      body: Column(
        children: [
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => {
                      _isStudentListActive = true,
                      _isAttendanceActive = false,
                      _toggleView(0)
                    },
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
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => {
                      _isStudentListActive = false,
                      _isAttendanceActive = true,
                      _toggleView(1)
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAttendanceActive
                          ? const Color(0xFFFF5E5E)
                          : Colors.grey[300],
                    ),
                    child: Text(
                      'Điểm danh',
                      style: TextStyle(
                        color: _isAttendanceActive
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (_isStudentListActive) _buildStudentList(),
                  if (_isAttendanceActive) _buildAttendanceView(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(currentIndex: currentIndex,),
    );
  }
}
