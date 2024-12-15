import 'package:flutter/material.dart';

import '../ui/components/footer.dart';
import '../ui/components/header.dart';

class ClassDetailPage extends StatefulWidget {
  const ClassDetailPage({super.key});

  @override
  State<ClassDetailPage> createState() => _ClassDetailPageState();
}

class _ClassDetailPageState extends State<ClassDetailPage> {
  int _currentIndex = 0;
  bool _isStudentListActive = true;
  DateTime _selectedDate = DateTime.now();
  TextEditingController _searchController = TextEditingController();
  List<String> _students = ['Lê Văn Tuấn Đạt', 'Nguyễn Văn A', 'Trần Thị B']; // Example student list
  List<bool> _attendanceStatus = [false, false, false]; // Track attendance status of students
  List<String> _notes = ['', '', '']; // Track notes for students


  void _toggleView(bool isStudentList) {
    setState(() {
      _isStudentListActive = isStudentList;
    });
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // Save the current attendance state
  void _saveAttendance() {
    // Implement your save logic here (e.g., send data to a server or save locally)
    print('Attendance Saved');
    for (int i = 0; i < _students.length; i++) {
      print('${_students[i]}: ${_attendanceStatus[i]} - Note: ${_notes[i]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Header(
          title: 'Thông tin chi tiết lớp',
          onBack: () {
            Navigator.pop(context);
          },
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
          const SizedBox(height: 10),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  // Filter student list based on search query
                  _students = _students.where((student) {
                    return student.toLowerCase().contains(query.toLowerCase());
                  }).toList();
                });
              },
              decoration: InputDecoration(
                labelText: 'Tìm kiếm sinh viên',
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          // Dynamic Content for Attendance View
          Expanded(
            child: !_isStudentListActive ? _buildAttendanceView() : _buildStudentList(),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
        currentIndex: _currentIndex,
      ),
    );
  }

  Widget _buildStudentList() {
    return ListView.builder(
      itemCount: _students.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey,
            child: Icon(Icons.circle_outlined, color: Color(0xFFFF5E5E), size: 20),
          ),
          title: Text(
            _students[index],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text('20215341'),
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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Student Name Column
                    Expanded(
                      child: Text(
                        _students[index], // Student name
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
}
