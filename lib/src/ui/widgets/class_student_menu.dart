import 'package:flutter/material.dart';

class ClassStMenu extends StatefulWidget {
  @override
  _ClassStMenuState createState() => _ClassStMenuState();
}

class _ClassStMenuState extends State<ClassStMenu> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> menuItems = [
    {
      'title': 'Danh sách sinh viên',
      'icon': 'assets/icons/news.png',
      'route': '/class-list-student'
    },
    {'title': 'Bài tập', 'icon': 'assets/icons/news.png'},
    {'title': 'Tài liệu', 'icon': 'assets/icons/news.png'},
    {
      'title': 'Thông báo',
      'icon': 'assets/icons/news.png',
      'route': '/notification'
    },
    {'title': 'Nhập điểm', 'icon': 'assets/icons/news.png'},
    {'title': 'Tin nhắn', 'icon': 'assets/icons/news.png'},
    {'title': 'Khảo sát', 'icon': 'assets/icons/news.png'},
    {'title': 'Cập nhật thông tin', 'icon': 'assets/icons/news.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: (menuItems.length / 4).ceil(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, pageIndex) {
              // Lấy danh sách các mục trong từng trang
              final items = menuItems
                  .skip(pageIndex * 4)
                  .take(4)
                  .map((item) => _buildMenuItem(
                      item['title']!, item['icon'], item['route'] ?? ''))
                  .toList();

              return GridView.count(
                crossAxisCount: 4,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: items,
              );
            },
          ),
        ),
        // Thanh chỉ mục
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            (menuItems.length / 4).ceil(),
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index ? Colors.red : Colors.grey,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(String title, String assetPath, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route); // Chuyển sang route tương ứng
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              assetPath, // Sử dụng Image.asset để hiển thị icon từ thư mục assets
              width: 32,
              height: 32,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          // Modify the Text widget to allow wrapping
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
            softWrap: true, // Allow text to wrap
            overflow: TextOverflow
                .ellipsis, // Optional: add an ellipsis if the text is too long for available space
          ),
        ],
      ),
    );
  }
}
