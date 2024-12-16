import 'dart:convert';
import 'package:http/http.dart' as http;

class AbsenceService {
  static const String baseUrl = 'http://157.66.24.126:8080'; // Replace with the actual base URL

  Future<List<Map<String, String>>> fetchAbsenceRequests({
    required String token,
    required String classId,
    String? status,
    String? date,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/it5023e/get_absence_requests'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          'class_id': classId,
          'status': status,
          'date': date,
          'pageable_request': {
            'page': '0',
            'page_size': '2',
          },
        }),
      );

      if (response.statusCode == 200) {
        // Ensure proper UTF-8 decoding of the response body
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        // Check if the API response was successful
        if (responseData['meta']['code'] == '1000') {
          List<dynamic> absenceRequestsData = responseData['data']['page_content'];

          // Create a list of maps to hold the absence request details
          List<Map<String, String>> absenceRequests = [];
          for (var request in absenceRequestsData) {
            var studentAccount = request['student_account'];
            String sender = '${studentAccount['first_name']} ${studentAccount['last_name']} - ${studentAccount['student_id']}';
            String date = request['absence_date'];
            String status = request['status'];

            // Add the absence request details to the list
            absenceRequests.add({
              'date': date,
              'sender': sender,
              'status': status,
            });
          }

          return absenceRequests;
        } else {
          print('Error: ${responseData['meta']['message']}');
          return [];
        }
      } else {
        print('Failed to load absence requests');
        return [];
      }
    } catch (e) {
      print('Error during API request: $e');
      return [];
    }
  }

  Future<bool> reviewAbsenceRequest({
    required String token,
    required String requestId,
    required String status, // ACCEPTED, PENDING, REJECTED
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/it5023e/review_absence_request'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
          'request_id': requestId,
          'status': status,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        // Check if the API response was successful
        if (responseData['meta']['code'] == '1000') {
          print('Absence request reviewed successfully');
          return true;
        } else {
          print('Error: ${responseData['meta']['message']}');
          return false;
        }
      } else {
        print('Failed to review absence request');
        return false;
      }
    } catch (e) {
      print('Error during API request: $e');
      return false;
    }
  }
}
