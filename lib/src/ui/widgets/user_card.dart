import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final String name;
  final String id;

  const UserCard({
    Key? key,
    required this.name,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          // Ảnh đại diện
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.red.shade100,
            child: const Icon(
              Icons.person,
              color: Colors.red,
              size: 32,
            ),
          ),
          const SizedBox(width: 12),
          // Thông tin người dùng
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                id,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
