import 'package:flutter/material.dart';
import 'package:it_4788/src/ui/components/footer.dart';
import 'package:it_4788/src/ui/components/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/widgets/class_card.dart';

class ListClassView extends StatefulWidget {
  const ListClassView({Key? key}) : super(key: key);

  @override
  _ListClassViewState createState() => _ListClassViewState();
}

class _ListClassViewState extends State<ListClassView> {
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

  void _onTabSelected(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Map<String, String>> menuItems = [
    {
      'title': 'Thời khóa biểu',
      'subtitle': 'Tra cứu thời khóa biểu, lịch thi',
      'icon': 'assets/icons/calendar.png', // Thay bằng icon thực tế
    },
    {
      'title': 'Đồ án',
      'subtitle': 'Thông tin các đồ án',
      'icon': 'assets/icons/project.png',
    },
    {
      'title': 'Thông báo tin tức',
      'subtitle': 'Các thông báo quan trọng',
      'icon': 'assets/icons/news.png',
    },
    {
      'title': 'Kết quả học tập',
      'subtitle': 'Thông tin kết quả học tập',
      'icon': 'assets/icons/result.png',
    },
    {
      'title': 'Lớp sinh viên',
      'subtitle': 'Thông tin về lớp của sv',
      'icon': 'assets/icons/class.png',
    },
    {
      'title': 'Tiện ích',
      'subtitle': 'Sổ tay sinh viên, bản đồ',
      'icon': 'assets/icons/tool.png',
    },
    {
      'title': 'Biểu mẫu online',
      'subtitle': 'Bảng điểm, chứng nhận sv...',
      'icon': 'assets/icons/form.png',
    },
    {
      'title': 'Học phí',
      'subtitle': 'Thông tin chi tiết về học phí',
      'icon': 'assets/icons/tuition.png',
    },
  ];

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
      body: ListView(
        children: const [
          ClassCard(
            startTime: "14:10",
            endTime: "17:10",
            courseCode: "154052",
            courseName: "Phát triển ứng dụng đa nền tảng",
            location: "TC - 207",
            scheduleDetail: "Sáng thứ 3, tiết 1 - 4",
            week: "Tuần 10",
          ),
        ],
      ),

      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
      ),
    );
  }
}
