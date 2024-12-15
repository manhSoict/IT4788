import 'package:flutter/material.dart';
import 'package:it_4788/src/ui/components/footer.dart';
import 'package:it_4788/src/ui/components/header.dart';
import 'package:it_4788/src/ui/widgets/class_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/components/header2.dart';
import '../ui/widgets/class_card.dart';
import '../ui/widgets/class_student_menu.dart';

class ClassDetailView extends StatefulWidget {
  const ClassDetailView({Key? key}) : super(key: key);

  @override
  _ClassDetailViewState createState() => _ClassDetailViewState();
}

class _ClassDetailViewState extends State<ClassDetailView> {
  String? role;
  String? name;
  String? studentId;
  String? startTime;
  String? endTime;
  String? classId;
  String? className;
  String? location;
  String? scheduleDetail;
  String? week;
  String? classType;
  String? attachedCode;
  String? lecturerName;
  String? studentCount;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role'); // Ví dụ: Sinh viên/Giảng viên
      name = prefs.getString('name');
      studentId = prefs.getString('studentId');
      classId = prefs.getString('classId');
      className = prefs.getString('className');
      startTime = prefs.getString('startTime');
      endTime = prefs.getString('endTime');
      location = prefs.getString('location');
      scheduleDetail = prefs.getString('scheduleDetail');
      week = prefs.getString('week');
      attachedCode = prefs.getString('attachedCode');
      lecturerName = prefs.getString('lecturerName');
      classType = prefs.getString('classType');
      studentCount = prefs.getString('studentCount');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền sáng
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: const Header2(title: 'Thông tin chi tiết lớp'),
      ),
      body: Column(
        children: [
          ClassDetail(
            courseCode: classId ?? '',
            courseName: className ?? '',
            schedule: scheduleDetail ?? '',
            date: "2 - 9, 11 - 18",
            classCode: classId ?? '',
            classType: classType ?? '',
            lecturerName: lecturerName ?? '',
            studentCount: studentCount ?? '',
            accessCode: attachedCode ?? '',
            link: "Link",
            materialLink: "Link",
          ),
          const SizedBox(height: 18),
          Expanded(
            child: ClassStMenu(), // Wrap ClassStMenu with Expanded
          ),
          const SizedBox(height: 18),
        ],
      ),

      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
      ),
    );
  }
}
