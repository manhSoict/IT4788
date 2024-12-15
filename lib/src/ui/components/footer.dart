import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const Footer({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, -2), // Đổ bóng lên trên
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTabItem(
            context: context,
            index: 0,
            icon: Icons.home,
            label: 'Trang chủ',
            routeName: '/home',
          ),
          _buildTabItem(
            context: context,
            index: 1,
            icon: Icons.search,
            label: 'Tin nhắn',
            routeName: '/messages',
          ),
          _buildTabItem(
            context: context,
            index: 2,
            icon: Icons.person,
            label: 'Setting',
            routeName: '/setting',
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
    required String routeName,
  }) {
    final bool isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () {
        if (index != currentIndex) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFFFF5E5E) : Colors.grey,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFFFF5E5E) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
