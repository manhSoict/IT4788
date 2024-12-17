import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationItem {
  final int id;
  final String message; // Tương ứng với 'detail'
  String status;
  final int fromUser;
  final int toUser;
  final String type;
  final String sentTime; // Tương ứng với 'date'
  final Map<String, dynamic> data;
  final String title;

  NotificationItem({
    required this.id,
    required this.message,
    required this.status,
    required this.fromUser,
    required this.toUser,
    required this.type,
    required this.sentTime,
    required this.data,
    required this.title,
  });

  // Factory method from JSON
  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      fromUser: json['from_user'] ?? 0,
      toUser: json['to_user'] ?? 0,
      type: json['type'] ?? '',
      sentTime: json['sent_time'] ?? '',
      data: json['data'] ?? {},
      title: json['title_push_notification'] ?? '',
    );
  }

  // Getter isRead to check if the notification is read
  bool get isRead => status == 'READ';

  // Getter detail to match with the field message
  String get detail => message;

  // Getter date to match with the field sentTime
  String get date => sentTime;
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationItem>> _futureNotifications;

  @override
  void initState() {
    super.initState();
    _futureNotifications =
        Future.value([]); // Khởi tạo _futureNotifications với giá trị mặc định
    _loadToken(); // Gọi hàm lấy token từ SharedPreferences
  }

  // Hàm lấy token từ SharedPreferences
  Future<void> _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Lấy token từ SharedPreferences

    if (token != null) {
      setState(() {
        // Gọi fetchNotifications với token từ SharedPreferences
        _futureNotifications = NotificationService.fetchNotifications(token);
      });
    } else {
      // Xử lý khi không có token trong SharedPreferences
      print('Token không tìm thấy');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: Colors.red.shade700,
      ),
      body: FutureBuilder<List<NotificationItem>>(
        future: _futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Không có thông báo nào'));
          } else {
            final notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(
                  notification: notifications[index],
                  onTap: () async {
                    // Gọi hành động cần thiết khi nhấn vào thông báo
                    notifications[index].status = 'READ';
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? token = prefs.getString('token');

                    if (token != null) {
                      try {
                        // Gửi API đánh dấu thông báo là đã đọc
                        await NotificationReadService.markNotificationAsRead(
                            token, notifications[index].id);

                        // Chuyển đến trang chi tiết thông báo
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificationDetail(
                              notification: notifications[index],
                            ),
                          ),
                        );
                      } catch (e) {
                        print('Lỗi khi đánh dấu thông báo là đã đọc: $e');
                      }
                    } else {
                      print('Token không tìm thấy');
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class NotificationService {
  static const String apiUrl =
      'http://157.66.24.126:8080/it5023e/get_notifications'; // Thay bằng URL API của bạn

  static Future<List<NotificationItem>> fetchNotifications(String token) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "index": 0,
        "count": 20,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes)); // Updated here
      final List<dynamic> notifications = data['data'];
      return notifications.map((e) => NotificationItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load notifications');
    }
  }
}

class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;

  const NotificationCard(
      {Key? key, required this.notification, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      color: notification.isRead ? Colors.white : Colors.blue.shade50,
      child: InkWell(
        onTap: () async {
          // Lấy token từ SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString('token');

          if (token != null) {
            try {
              // Gửi API đánh dấu thông báo là đã đọc
              await NotificationReadService.markNotificationAsRead(
                  token, notification.id);

              // Chuyển đến trang chi tiết thông báo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationDetail(
                    notification:
                        notification, // Sử dụng notification thay vì notifications[index]
                  ),
                ),
              );

              // Gọi onTap để thực hiện các hành động khác nếu cần
              onTap();
            } catch (e) {
              // Nếu có lỗi khi gửi API, hiển thị thông báo lỗi
              print('Lỗi khi đánh dấu thông báo là đã đọc: $e');
            }
          } else {
            print('Token không tìm thấy');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'ALLHUST',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    notification.date, // Sử dụng getter date
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notification.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              const Divider(),
              Text(
                notification.detail, // Sử dụng getter detail
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationDetail extends StatelessWidget {
  final NotificationItem notification;

  const NotificationDetail({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết thông báo'),
        backgroundColor: Colors.red.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Ngày: ${notification.date}',
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              notification.detail,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Quay lại trang trước và reload trang NotificationScreen
                Navigator.pop(context); // Quay lại trang trước
                // Gọi _loadToken() lại để reload dữ liệu từ NotificationScreen
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()),
                );
              },
              child: const Text("Quay lại danh sách thông báo"),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationReadService {
  static const String apiUrlMarkAsRead =
      'http://157.66.24.126:8080/it5023e/mark_notification_as_read'; // Thay bằng URL API chính xác

  static Future<void> markNotificationAsRead(
      String token, int notificationId) async {
    final response = await http.post(
      Uri.parse(apiUrlMarkAsRead),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "token": token,
        "notification_id": notificationId.toString(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Lỗi khi đánh dấu thông báo là đã đọc');
    }
  }
}
