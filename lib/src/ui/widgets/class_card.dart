import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassCard extends StatelessWidget {
  final String startTime;
  final String endTime;
  final String classId;
  final String className;
  final String location;
  final String scheduleDetail;
  final String week;
  final String? attachedCode;
  final String? lecturerName;
  final String lecturerId;
  final String status;
  final String classType;
  final String studentCount;

  const ClassCard(
      {Key? key,
      required this.startTime,
      required this.endTime,
      required this.classId,
      required this.className,
      required this.location,
      required this.scheduleDetail,
      required this.week,
      this.attachedCode,
      this.lecturerName,
      required this.lecturerId,
      required this.classType,
      required this.status,
      required this.studentCount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('classId', classId);
        print('Course code saved: $classId');
        await prefs.setString('className', className);
        await prefs.setString('endTime', endTime);
        await prefs.setString('startTime', startTime);
        await prefs.setString('location', location);
        await prefs.setString('scheduleDetail', scheduleDetail);
        await prefs.setString('week', week);
        await prefs.setString('attachedCode', attachedCode ?? '');
        await prefs.setString('lecturerName', lecturerName ?? '');
        await prefs.setString('lecturerId', lecturerId);
        await prefs.setString('status', status);
        await prefs.setString('classType', classType);
        await prefs.setString('studentCount', studentCount);

        // Chuyển sang màn hình chi tiết lớp học
        Navigator.pushNamed(context, '/classdetail');
      },
      child: Card(
        color: Colors.pink.shade50, // Màu nền của thẻ
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Bo góc cho thẻ
        ),
        margin: const EdgeInsets.symmetric(
            vertical: 8, horizontal: 16), // Khoảng cách ngoài
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Khoảng cách bên trong
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cột thời gian
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Thời gian bắt đầu
                  Text(
                    startTime,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8), // Khoảng cách giữa các thành phần
                  const Icon(
                    Icons.access_time, // Biểu tượng đồng hồ
                    size: 20,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 8), // Khoảng cách
                  // Thời gian kết thúc
                  Text(
                    endTime,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                  width:
                      16), // Khoảng cách giữa cột thời gian và chi tiết khóa học
              // Cột chi tiết khóa học
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Mã và tên khóa học
                    Text(
                      "$classId - $className",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Chi tiết lịch học
                    Text(
                      scheduleDetail,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Địa điểm học
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tuần học
                    Text(
                      "• $week",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
              ),
              // Icon chuyển tiếp
              Center(
                child: const Icon(
                  Icons.chevron_right,
                  color: Colors.black54,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
