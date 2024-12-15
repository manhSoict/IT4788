import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../services/logout_service.dart';

class MenuItem extends StatelessWidget {
  final String title;

  const MenuItem({super.key, required this.title});

  Future<void> _handleLogout(BuildContext context) async {
    // Lấy token từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    final token = null;
    print(token);

    if (token == null) {
      // Nếu không có token, chuyển về màn hình đăng nhập
      Navigator.pushReplacementNamed(context, '/');
      return;
    }

    // Gọi API logout
    final success = await LogoutService.logout(token);

    if (success) {
      // Xóa token trong SharedPreferences
      await prefs.remove('token');

      // Chuyển về màn hình đăng nhập
      Navigator.pushReplacementNamed(context, '/');
    } else {
      // Hiển thị thông báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đăng xuất thất bại. Vui lòng thử lại!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (title == 'Đăng xuất') {
          _handleLogout(context); // Gọi hàm đăng xuất
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
