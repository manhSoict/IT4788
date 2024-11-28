import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String? role; // Vai trò: "Sinh viên", "Giảng viên", hoặc null
  final String? name; // Tên người dùng
  final String? studentId; // Mã số sinh viên (nếu có)
  final String? title; // Tiêu đề (nếu hiển thị thông tin lớp)
  final VoidCallback? onBack; // Hàm callback khi nhấn nút quay lại
  final String? logoPath = 'assets/images/logo.png';

  const Header({
    super.key,
    this.role,
    this.name,
    this.studentId,
    this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFF5E5E), // Màu đỏ
      automaticallyImplyLeading: false, // Không tự động thêm nút quay lại
      leading: onBack != null
          ? IconButton(
              // Chỉ hiển thị nút quay lại khi onBack không null
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBack,
            )
          : Padding(
              // Nếu không có nút quay lại, hiển thị logo
              padding: const EdgeInsets.only(
                  top: 8.0, left: 8.0), // Thêm khoảng cách bên trái
              child: Image.asset(
                logoPath!,
                width: 30, // Chiều rộng của logo
                height: 30, // Chiều cao của logo
              ),
            ),
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                Text(
                  name ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
      actions: title == null
          ? [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {
                  // Xử lý thông báo
                },
              ),
            ]
          : null,
    );
  }
}
