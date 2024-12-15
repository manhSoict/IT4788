import 'package:flutter/material.dart';

class Header2 extends StatelessWidget {
  final String title;

  const Header2({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFF5E5E), // Màu nền đỏ
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          const SizedBox(height: 38),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Quay lại trang trước
            },
            child: const Icon(
              Icons.arrow_back, // Icon mũi tên quay lại
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16), // Khoảng cách giữa icon và tiêu đề
          Text(
            title,
            style: const TextStyle(
              color: Colors.white, // Màu chữ trắng
              fontSize: 18, // Kích cỡ chữ
              fontWeight: FontWeight.bold, // Đậm chữ
            ),
          ),
          const SizedBox(height: 28),
        ],
      ),
    );
  }
}
