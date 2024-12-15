import 'package:flutter/material.dart';

class ClassDetail extends StatelessWidget {
  final String courseCode;
  final String courseName;
  final String schedule;
  final String date;
  final String classCode;
  final String type;
  final int studentCount;
  final String accessCode;
  final String link;
  final String materialLink;

  const ClassDetail({
    Key? key,
    required this.courseCode,
    required this.courseName,
    required this.schedule,
    required this.date,
    required this.classCode,
    required this.type,
    required this.studentCount,
    required this.accessCode,
    required this.link,
    required this.materialLink,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course Title
            Text(
              "$courseCode - $courseName",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            // Schedule Info
            Text(
              schedule,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              "Ngày: $date",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            // Details Table
            Row(
              children: [
                _buildDetailLabel("Mã lớp:"),
                SizedBox(
                    width: screenWidth *
                        0.2), // Thêm khoảng cách giữa label và value
                _buildDetailValue(classCode),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDetailLabel("Loại hình:"),
                SizedBox(width: screenWidth * 0.2),
                _buildDetailValue(type),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDetailLabel("Hệ:"),
                SizedBox(width: screenWidth * 0.2),
                _buildDetailValue("CN"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDetailLabel("Kỳ:"),
                SizedBox(width: screenWidth * 0.2),
                _buildDetailValue("20241"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDetailLabel("Số sinh viên:"),
                SizedBox(width: screenWidth * 0.2),
                _buildDetailValue(studentCount.toString()),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDetailLabel("Hình thức:"),
                SizedBox(width: screenWidth * 0.2),
                _buildDetailValue("Offline"),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDetailLabel("Mã truy cập lớp:"),
                SizedBox(width: screenWidth * 0.2),
                _buildDetailValue(accessCode),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildDetailLabel("Link:"),
                SizedBox(width: screenWidth * 0.2),
                _buildDetailValue(
                  link,
                  isLink: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailLabel(String label) {
    return SizedBox(
      width: 100,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildDetailValue(String value, {bool isLink = false}) {
    return Expanded(
      child: GestureDetector(
        onTap: isLink ? () => print("Tapped on $value") : null,
        child: Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isLink ? Colors.blue : Colors.black,
            decoration: isLink ? TextDecoration.underline : null,
          ),
        ),
      ),
    );
  }
}
