import 'package:flutter/material.dart';

class NotificationItem {
  final String title;
  final String detail; // Nội dung đầy đủ của thông báo
  final String date;
  final bool isRead;

  NotificationItem({
    required this.title,
    required this.detail,
    required this.date,
    this.isRead = false,
  });
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: 'Chương trình tham quan công ty Công nghiệp Brother Việt Nam',
        detail: 'Công ty TNHH Brother Việt Nam là công ty 100% vốn đầu tư...',
        date: '03/12/2024',
        isRead: false,
      ),
      NotificationItem(
        title: 'Mời bạn tham dự các chương trình Hội thảo tại Career Day 2024',
        detail:
            'Nhà trường phối hợp cùng các doanh nghiệp tổ chức NGÀY HỘI HƯỚNG NGHIỆP...',
        date: '02/12/2024',
        isRead: true,
      ),
      NotificationItem(
        title:
            'Thông báo thay đổi lịch dạy lớp 154041 - Thiết kế và xây dựng phần mềm',
        detail: 'Thông báo thay đổi lịch dạy lớp 154041 sang thứ 4, 5...',
        date: '25/11/2024',
        isRead: false,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        backgroundColor: Colors.red.shade700,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationCard(
            notification: notifications[index],
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      NotificationDetail(notification: notifications[index]),
                ),
              );
            },
          );
        },
      ),
    );
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
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ALLHUST góc trái trên cùng
                  const Text(
                    'ALLHUST',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  // Date góc phải trên cùng
                  Text(
                    notification.date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Title
              Text(
                notification.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              // Đường ngăn cách
              const Divider(),
              // Tóm tắt Detail
              Text(
                notification.detail,
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
          ],
        ),
      ),
    );
  }
}
