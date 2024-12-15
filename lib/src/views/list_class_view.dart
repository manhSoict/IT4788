import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:it_4788/src/ui/components/footer.dart';
import 'package:it_4788/src/ui/components/header.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui/components/header2.dart';
import '../ui/widgets/class_card.dart';
import '../services/listclass_service.dart';
import 'dart:math'; // For random times
import 'package:intl/intl.dart'; // Đảm bảo bạn đã import intl
import 'package:intl/intl_standalone.dart'; // Import thêm để sử dụng initializeDateFormatting

class ListClassView extends StatefulWidget {
  const ListClassView({Key? key}) : super(key: key);

  @override
  _ListClassViewState createState() => _ListClassViewState();
}

class _ListClassViewState extends State<ListClassView> {
  String? role;
  String? name;
  String? studentId;
  String? token;
  int currentIndex = 0;
  List<ClassCard> classCards = [];

  @override
  void initState() {
    super.initState();
    _initializeLocale(); // Khởi tạo locale
    _loadUserData();
  }

  // Khởi tạo dữ liệu locale
  Future<void> _initializeLocale() async {
    await initializeDateFormatting(
        'vi_VN', null); // Khởi tạo dữ liệu locale Tiếng Việt
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      role = prefs.getString('role');
      name = prefs.getString('name');
      studentId = prefs.getString('studentId');
      token = prefs.getString('token');
    });
    if (token != null && role != null) {
      await _fetchAndDisplayClasses();
    }
  }

  Future<void> _fetchAndDisplayClasses() async {
    try {
      // Sử dụng dịch vụ để gọi API và nhận danh sách lớp
      final classes = await ListClassService().fetchClasses(
        token: token!,
        role: role!,
      );

      // Chuyển đổi danh sách lớp thành ClassCard
      final List<ClassCard> loadedClasses = classes.map((item) {
        final startDate = DateTime.parse(item.startDate);
        final weekDifference = _calculateWeekDifference(startDate);
        final scheduleDetail = _getScheduleDetail(startDate);
        final times = _generateRandomTimes();

        return ClassCard(
          startTime: times[0],
          endTime: times[1],
          classId: item.classId,
          className: item.className,
          location: "TC - 207", // Giả định vị trí cố định
          scheduleDetail: scheduleDetail,
          week: "Tuần $weekDifference",
          attachedCode: item.attachedCode ?? '',
          lecturerId: item.lecturerId,
          lecturerName: item.lecturerName,
          status: item.status,
          studentCount: item.studentCount,
          classType: item.classType,
        );
      }).toList();

      setState(() {
        classCards = loadedClasses;
      });
    } catch (e) {
      print('Error fetching classes: $e');
    }
  }

  int _calculateWeekDifference(DateTime startDate) {
    final now = DateTime.now();
    return (now.difference(startDate).inDays ~/ 7) + 1;
  }

  String _getScheduleDetail(DateTime startDate) {
    final dayOfWeek = DateFormat('EEEE', 'vi')
        .format(startDate); // Đảm bảo 'vi' là locale đã được khởi tạo
    final random = Random();
    final session = random.nextBool() ? "Sáng" : "Chiều";
    final periods = random.nextInt(4) + 1; // Tiết học từ 1 đến 4
    return "$session $dayOfWeek, tiết 1 - $periods";
  }

  List<String> _generateRandomTimes() {
    final random = Random();
    final startHour = random.nextInt(4) + 7; // 7:00 - 10:00
    final endHour = startHour + 3; // Kết thúc sau 3 giờ
    return ["$startHour:00", "$endHour:00"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Header2(title: "Danh sách lớp")),
      body: classCards.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Căn Text về bên trái
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0), // Thêm padding xung quanh Text
                  child: Text(
                    'Kì 20241',
                    style: TextStyle(
                      fontSize: 25, // Kích thước chữ
                      fontWeight: FontWeight.bold, // Chữ in đậm
                    ),
                  ),
                ),
                Expanded(
                  // Đảm bảo ListView.builder có đủ không gian
                  child: ListView.builder(
                    itemCount: classCards.length,
                    itemBuilder: (context, index) {
                      return classCards[index];
                    },
                  ),
                ),
              ],
            ),
      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
      ),
    );
  }
}
