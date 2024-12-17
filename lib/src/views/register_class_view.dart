import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/listclass_service.dart';
import '../models/class.dart';
import '../ui/components/footer.dart';
import '../ui/components/header2.dart';

class RegisterClassView extends StatefulWidget {
  const RegisterClassView({Key? key}) : super(key: key);

  @override
  _RegisterClassViewState createState() => _RegisterClassViewState();
}

class _RegisterClassViewState extends State<RegisterClassView> {
  final TextEditingController _classIdController = TextEditingController();
  String? token;
  String? role;
  List<Class> classes = [];
  int currentIndex = 0;



  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      role = prefs.getString('role');
    });
    if (token != null && role != null) {
      await _fetchClasses();
    }
  }

  Future<void> _fetchClasses() async {
    try {
      final fetchedClasses = await ListClassService().fetchClasses(
        token: token!,
        role: role!,
      );
      setState(() {
        classes = fetchedClasses;
      });
    } catch (e) {
      print("Error fetching classes: $e");
    }
  }

  void _handleRegisterClass() {
    final enteredClassId = _classIdController.text.trim();

    if (enteredClassId.isEmpty) {
      _showDialog("Lỗi", "Vui lòng nhập mã lớp.");
      return;
    }

    final classFound = classes.any((cls) => cls.classId == enteredClassId);

    if (classFound) {
      _showDialog("Thành công", "Bạn đã đăng ký lớp $enteredClassId thành công!");
    } else {
      _showDialog("Lỗi", "Mã lớp $enteredClassId không tồn tại. Vui lòng kiểm tra lại.");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Đóng"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Header2(
          title: 'Đăng ký lớp', // Tiêu đề trong Header2
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nhập mã lớp:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _classIdController,
              decoration: InputDecoration(
                hintText: "Nhập mã lớp (VD: CLS1234)",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5E5E), // Nền đỏ
                  foregroundColor: Colors.white, // Chữ trắng
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: _handleRegisterClass,
                child: const Text(
                  "Đăng ký",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
      ),
    );
  }
}
