import 'package:flutter/material.dart';
import 'package:it_4788/src/ui/components/footer.dart';
import 'package:it_4788/src/ui/components/header.dart';
import 'package:it_4788/src/ui/widgets/class_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/widgets/class_card.dart';
import '../ui/widgets/user_card.dart';

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = (prefs.getString('role') == "STUDENT")
          ? 'Sinh viên'
          : 'Giảng viên'; // Ví dụ: Sinh viên/Giảng viên
      name = prefs.getString('name');
      studentId = prefs.getString('studentId');
    });
    print(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền sáng
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Header(
          role: role,
          name: name,
          studentId: studentId,
          title: currentIndex == 2 ? 'Thông tin chi tiết lớp' : null,
          onBack: currentIndex == 2
              ? () {
                  setState(() {
                    currentIndex = 0; // Quay lại Trang chủ
                  });
                }
              : null,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClassDetail(
              courseCode: "IT4788",
              courseName: "Phát triển ứng dụng đa nền tảng",
              schedule: "Tiết 1 - 4, Sáng thứ 3, TC - 207",
              date: "2 - 9, 11 - 18",
              classCode: "154052",
              type: "LT + BT",
              studentCount: 26,
              accessCode: "5xkzphk",
              link: "5xkzphk",
              materialLink: "Link",
            ),
            UserCard(name: "Trương Thùy Trang", id: "20071107"),
            UserCard(name: "Nguyễn Đức Mạnh", id: "20215420"),
          ],
        ),
      ),

      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
      ),
    );
  }
}
