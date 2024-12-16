import 'package:flutter/material.dart';
import 'package:it_4788/src/services/absence_service.dart';
import 'package:it_4788/src/ui/components/card/RequestCard.dart';
import 'package:it_4788/src/ui/components/header2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  DateTime _selectedDate = DateTime.now();
  String? token;
  String? classId;
  final AbsenceService _absenceService = AbsenceService();

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      token = prefs.getString('token');
      classId = prefs.getString('classId');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Màu nền sáng
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: const Header2(title: 'Thông tin chi tiết lớp'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text(
                  'Chọn ngày: ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF5E5E)),
                  onPressed: _selectDate,
                  child: Text(
                    "${_selectedDate.toLocal()}".split(' ')[0],
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Map<String, String>>>(
            future: _absenceService.fetchAbsenceRequests(
              token: token!,
              classId: classId!,
              status: null,
              date: _selectedDate.toString().split(' ')[0],
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No notifications found.'));
              } else {
                List<Map<String, String>> notifications = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    var notification = notifications[index];
                    return RequestCard(
                      date: notification['date'] ?? 'Unknown Date',
                      sender: notification['sender'] ?? 'Unknown Sender',
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
