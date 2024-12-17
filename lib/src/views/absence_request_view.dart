import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/class.dart';
import '../services/listclass_service.dart';
import '../ui/components/footer.dart';
import '../ui/components/header2.dart';

class AbsenceRequestView extends StatefulWidget {
  const AbsenceRequestView({Key? key}) : super(key: key);

  @override
  _AbsenceRequestViewState createState() => _AbsenceRequestViewState();
}

class _AbsenceRequestViewState extends State<AbsenceRequestView> {
  String? selectedClass;
  DateTime selectedDate = DateTime.now();
  TextEditingController reasonController = TextEditingController();
  List<Class> classList = [];
  String? role;
  String? name;
  String? studentId;
  String? token;
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
      name = prefs.getString('name');
      studentId = prefs.getString('studentId');
    });
    if (token != null && role != null) {
      await _fetchClasses();
    }
  }

  Future<void> _fetchClasses() async {
    try {
      List<Class> classes = await ListClassService().fetchClasses(
        token: token!,
        role: role!,
      );
      setState(() {
        classList = classes;
      });
    } catch (e) {
      print("Error fetching classes: $e");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _submitRequest() {
    if (selectedClass == null || reasonController.text.isEmpty) {
      // Kiểm tra nếu lớp hoặc lý do chưa được chọn
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vui lòng chọn lớp và nhập lý do')),
      );
    } else {
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đơn xin nghỉ học đã được nộp')),
      );
      // Có thể thực hiện thêm logic để gửi dữ liệu tới API hoặc server ở đây
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: Header2(
          title: 'Xin phép vắng học', // Tiêu đề trong Header2
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Chọn lớp
            DropdownButton<String>(
              value: selectedClass,
              hint: Text('Chọn lớp'),
              isExpanded: true,
              items: classList.map((Class classItem) {
                return DropdownMenuItem<String>(
                  value: classItem.className, // Sử dụng thuộc tính tên lớp
                  child: Text(classItem.className),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedClass = value;
                });
              },
            ),

            const SizedBox(height: 16),

            // Chọn thời gian
            GestureDetector(
              onTap: () => _selectDate(context),
              child: AbsorbPointer(
                child: TextFormField(
                  controller: TextEditingController(
                    text: DateFormat('yyyy-MM-dd').format(selectedDate),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Chọn ngày',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Nhập lý do
            TextFormField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Lý do nghỉ',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // Nút nộp
            ElevatedButton(
                onPressed: _submitRequest,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFFFF5E5E), // Chữ trắng
                ),
                child: const Text('Nộp')
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
