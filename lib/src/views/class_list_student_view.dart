import 'package:flutter/material.dart';
import 'package:it_4788/src/ui/components/footer.dart';
import 'package:it_4788/src/ui/components/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassListStudentView extends StatefulWidget {
  const ClassListStudentView({Key? key}) : super(key: key);

  @override
  _ClassListStudentViewState createState() => _ClassListStudentViewState();
}

class _ClassListStudentViewState extends State<ClassListStudentView> {
  String? role;
  String? name;
  String? studentId;
  int currentIndex = 0;
  bool _isStudentListActive = true;
  TextEditingController _searchController = TextEditingController();
  List<String> _students = [
    "Trương Thùy Trang",
    "Nguyễn Đức Mạnh",
    "Phan Anh Tuấn",
    "Nguyễn Thị Lan"
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = (prefs.getString('role') == "STUDENT") ? 'Sinh viên' : 'Giảng viên';
      name = prefs.getString('name');
      studentId = prefs.getString('studentId');
    });
    print(name);
  }

  void _toggleView(bool isStudentListActive) {
    setState(() {
      _isStudentListActive = isStudentListActive;
    });
  }

  Widget _buildStudentList() {
    return ListView.builder(
      itemCount: _students.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_students[index]),
        );
      },
    );
  }

  Widget _buildAttendanceView() {
    return Center(child: Text('Attendance View'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Header(
          role: role,
          name: name,
          studentId: studentId,
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
        currentIndex: currentIndex,
      ),
    );
  }
}
