class Class {
  final String classId;
  final String className;
  final String? attachedCode;  // Có thể null
  final String classType;
  final String lecturerName;
  final String studentCount;
  final String startDate;
  final String endDate;
  final String status;

  Class({
    required this.classId,
    required this.className,
    this.attachedCode,  // Có thể null
    required this.classType,
    required this.lecturerName,
    required this.studentCount,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory Class.fromJson(Map<String, dynamic> json) {
    return Class(
      classId: json['class_id'],
      className: json['class_name'],
      attachedCode: json['attached_code'],  // Có thể null
      classType: json['class_type'],
      lecturerName: json['lecturer_name'],
      studentCount: json['student_count'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
    );
  }
}
