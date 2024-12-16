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
  String? userId;
  int currentIndex = 0;
  List? menuItems;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
      print(role);
      name = prefs.getString('name');
      userId = prefs.getString('userId');
    });
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    setState(() {
      menuItems = role == "STUDENT" ? menuItemsStudent : menuItemsLecturer;
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  final List<Map<String, String>> menuItemsStudent = [
    {
      'title': 'Danh sách lớp',
      'subtitle': 'Danh sách lớp sinh viên trong học kì',
      'icon': 'assets/icons/class.png',
      'route': '/listclass',
    },
    {
      'title': 'Bài tập',
      'subtitle': 'Bài tập của sinh viên',
      'icon': 'assets/icons/project.png',
      'route': '/project',
    },
    {
      'title': 'Đăng kí lớp',
      'subtitle': 'Đăng kí vào lớp có trong học kì',
      'icon': 'assets/icons/enrollment.png',
      'route': '/news',
    },
    {
      'title': 'Xin phép nghỉ học',
      'subtitle': 'Xin phép nghỉ học onlie',
      'icon': 'assets/icons/absent.png',
      'route': '/class',
    },
    {
      'title': 'Kết quả học tập',
      'subtitle': 'Thông tin kết quả học tập',
      'icon': 'assets/icons/result.png',
      'route': '/result',
    },
    {
      'title': 'Tiện ích',
      'subtitle': 'Sổ tay sinh viên, bản đồ',
      'icon': 'assets/icons/tool.png',
      'route': '/searchchat',
    },
    {
      'title': 'Học phí',
      'subtitle': 'Thông tin chi tiết về học phí',
      'icon': 'assets/icons/tuition.png',
      'route': '/chatview',
    },
  ];
  final List<Map<String, String>> menuItemsLecturer = [
    {
      'title': 'Danh sách lớp',
      'subtitle': 'Danh sách lớp sinh viên trong học kì',
      'icon': 'assets/icons/class.png',
      'route': '/listclass',
    },
    {
      'title': 'Tạo lớp',
      'subtitle': 'Đăng kí vào lớp có trong học kì',
      'icon': 'assets/icons/enrollment.png',
      'route': '/news',
    },
    {
      'title': 'Tiện ích',
      'subtitle': 'Sổ tay sinh viên, bản đồ',
      'icon': 'assets/icons/tool.png',
      'route': '/create-class',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền sáng
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Header(
          role: role == "STUDENT" ? 'Sinh viên' : 'Giảng viên',
          name: name,
          studentId: userId,
          title: currentIndex > 2 ? 'Thông tin chi tiết lớp' : null,
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
        child: menuItems == null || menuItems!.isEmpty
            ? Center(
                child:
                    CircularProgressIndicator()) // Hiển thị loading khi menuItems chưa có dữ liệu
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3 / 2.5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: menuItems?.length,
                itemBuilder: (context, index) {
                  final item = menuItems?[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, item['route']!);
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
