import 'dart:convert';
import 'package:http/http.dart' as http;

class ClassService {
  static const String baseUrl = 'http://157.66.24.126:8080'; // Update the base URL if needed

  Future<Map<String, String>> getStudentsOfClass({
    required String token,
    required String role,
    required String accountId,
    required String classId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/it5023e/get_class_info'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          'role': role,
          'account_id': accountId,
          'class_id': classId,
        }),
      );

      if (response.statusCode == 200) {
        // Ensure proper UTF-8 decoding of the response body
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        // Check if the API response was successful
        if (responseData['meta']['code'] == '1000') {
          List<dynamic> usersData = responseData['data']['student_accounts'];

          // Create a dictionary of "student_id" as key and "name" as value
          Map<String, String> studentsMap = {};
          for (var student in usersData) {
            String studentId = student['student_id'];
            String name = '${student['first_name']} ${student['last_name']}';
            studentsMap[studentId] = name;
          }
          return studentsMap;
        } else {
          print('Error: ${responseData['meta']['message']}');
          return {};
        }
      } else {
        print('Failed to load class data');
        return {};
      }
    } catch (e) {
      print('Error during API request: $e');
      return {};
    }
  }

  // Method to create a class
  Future<Map<String, dynamic>> createClass({
    required String token,
    required String classId,
    required String className,
    required String classType, // LT, BT, LT_BT
    required String startDate,
    required String endDate,
    required int maxStudentAmount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/it5023e/create_class'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          'class_id': classId,
          'class_name': className,
          'class_type': classType,
          'start_date': startDate,
          'end_date': endDate,
          'max_student_amount': maxStudentAmount,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        // Check if the API response was successful
        if (responseData['meta']['code'] == '1000') {
          return {'success': true, 'message': 'Class created successfully'};
        } else {
          return {'success': false, 'message': responseData['meta']['message']};
        }
      } else {
        return {'success': false, 'message': 'Failed to create class'};
      }
    } catch (e) {
      print('Error during API request: $e');
      return {'success': false, 'message': 'Error during API request'};
    }
  }

  // Method to edit a class
  Future<Map<String, dynamic>> editClass({
    required String token,
    required String classId,
    required String className,
    required String status, // ACTIVE, COMPLETED, UPCOMING
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/it5023e/edit_class'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          'class_id': classId,
          'class_name': className,
          'status': status, // Ensure valid status: "ACTIVE", "COMPLETED", "UPCOMING"
          'start_date': startDate,
          'end_date': endDate,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        // Check if the API response was successful
        if (responseData['meta']['code'] == '1000') {
          return {'success': true, 'message': 'Class edited successfully'};
        } else {
          return {'success': false, 'message': responseData['meta']['message']};
        }
      } else {
        return {'success': false, 'message': 'Failed to edit class'};
      }
    } catch (e) {
      print('Error during API request: $e');
      return {'success': false, 'message': 'Error during API request'};
    }
  }

}
