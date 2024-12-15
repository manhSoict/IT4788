import 'package:flutter/material.dart';
import 'package:it_4788/src/ui/components/footer.dart';
import 'package:it_4788/src/ui/components/header.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/components/card/UserInfoCard.dart';
import '../ui/components/menuitem/MenuItem.dart';

class SettingView extends StatefulWidget {
  const SettingView({super.key});

  @override
  State<SettingView> createState() => _SettingViewSate();
}

class _SettingViewSate extends State<SettingView> {
  String? role;
  String? name;
  String? studentId;
  int currentIndex = 2;

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
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          UserInfoCard(name: name ?? ''),
          const SizedBox(height: 20),
          Image.asset(
            'assets/images/HUST.png', // Add the logo image to assets
            height: 80,
          ),
          const SizedBox(height: 20),
          const MenuItem(title: 'Trợ giúp và hỗ trợ'),
          const MenuItem(title: 'Cài đặt và quyền riêng tư'),
          const MenuItem(title: 'Đăng xuất'),
        ],
      ),
      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
      ),
    );
  }
}
