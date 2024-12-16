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

  final List<Map<String, String>> menuItems = [
    {
      'title': 'Thời khóa biểu',
      'subtitle': 'Tra cứu thời khóa biểu, lịch thi',
      'icon': 'assets/icons/calendar.png',
      'route': '/listclass',
    },
    {
      'title': 'Đồ án',
      'subtitle': 'Thông tin các đồ án',
      'icon': 'assets/icons/project.png',
      'route': '/project',
    },
    {
      'title': 'Thông báo tin tức',
      'subtitle': 'Các thông báo quan trọng',
      'icon': 'assets/icons/news.png',
      'route': '/news',
    },
    {
      'title': 'Kết quả học tập',
      'subtitle': 'Thông tin kết quả học tập',
      'icon': 'assets/icons/result.png',
      'route': '/result',
    },
    {
      'title': 'Lớp sinh viên',
      'subtitle': 'Thông tin về lớp của sv',
      'icon': 'assets/icons/class.png',
      'route': '/class',
    },
    {
      'title': 'Tiện ích',
      'subtitle': 'Sổ tay sinh viên, bản đồ',
      'icon': 'assets/icons/tool.png',
      'route': '/create-class',
    },
    {
      'title': 'Biểu mẫu online',
      'subtitle': 'Bảng điểm, chứng nhận sv...',
      'icon': 'assets/icons/form.png',
      'route': '/forms',
    },
    {
      'title': 'Học phí',
      'subtitle': 'Thông tin chi tiết về học phí',
      'icon': 'assets/icons/tuition.png',
      'route': '/tuition',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2.5,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: menuItems.length,
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, item['route']!);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      item['icon']!,
                      width: 40,
                      height: 40,
                      color: Colors.red,
                    ),
                    SizedBox(height: 8),
                    Text(
                      item['title']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item['subtitle']!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
      ),
    );
  }
}
