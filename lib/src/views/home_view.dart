import 'package:flutter/material.dart';
import 'package:it_4788/src/ui/components/footer.dart';
import 'package:it_4788/src/ui/components/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
      body: Center(
        child: Text(
          currentIndex == 0
              ? 'Trang chủ'
              : currentIndex == 1
                  ? 'Tài khoản'
                  : 'Thông tin chi tiết lớp',
        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
