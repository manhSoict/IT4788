import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ExerciseService {
  static const String baseUrl = 'http://157.66.24.126:8080'; // Update base URL if needed

  // Create Exercise
  Future<Map<String, dynamic>> createExercise({
    required String token,
    required String classId,
    required String title,
    required String deadline,
    required String description,
    required File file, // File to upload
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/it5023e/create_survey?file=null'),
      );

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      request.fields['token'] = token;
      request.fields['classId'] = classId;
      request.fields['title'] = title;
      request.fields['deadline'] = deadline;
      request.fields['description'] = description;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = json.decode(responseBody);
        if (responseData['meta']['code'] == '1000') {
          return {'success': true, 'message': 'Exercise created successfully'};
        } else {
          return {'success': false, 'message': responseData['meta']['message']};
        }
      } else {
        return {'success': false, 'message': 'Failed to create exercise'};
      }
    } catch (e) {
      print('Error during API request: $e');
      return {'success': false, 'message': 'Error during API request'};
    }
  }

  // Retrieve all exercises
  Future<Map<String, dynamic>> getAllExercises({
    required String token,
    required String classId,
  }) async {
    try {
      var url = Uri.parse('$baseUrl/it5023e/get_all_surveys');
      var requestBody = json.encode({
        'token': token,
        'class_id': classId,
      });

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['meta']['code'] == '1000') {
          return {
            'success': true,
            'message': 'Exercises retrieved successfully',
            'data': responseData['data'],
          };
        } else {
          return {'success': false, 'message': responseData['meta']['message']};
        }
      } else {
        return {'success': false, 'message': 'Failed to retrieve exercises'};
      }
    } catch (e) {
      print('Error during API request: $e');
      return {'success': false, 'message': 'Error during API request'};
    }
  }

  // Edit Exercise
  Future<Map<String, dynamic>> editExercise({
    required String token,
    required int assignmentId,
    required String deadline,
    required String description,
    required File file, // Updated file if needed
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/it5023e/edit_survey'),
      );

      // Add file and fields
      request.files.add(await http.MultipartFile.fromPath('file', file.path));
      request.fields['token'] = token;
      request.fields['survey_id'] = assignmentId as String;
      request.fields['deadline'] = deadline;
      request.fields['description'] = description;

      var response = await request.send();

      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = json.decode(responseBody);
        if (responseData['meta']['code'] == '1000') {
          return {'success': true, 'message': 'Exercise edited successfully'};
        } else {
          return {'success': false, 'message': responseData['meta']['message']};
        }
      } else {
        return {'success': false, 'message': 'Failed to edit exercise'};
      }
    } catch (e) {
      print('Error during API request: $e');
      return {'success': false, 'message': 'Error during API request'};
    }
  }

  // Delete Exercise
  Future<Map<String, dynamic>> deleteExercise({
    required String token,
    required int surveyId,
  }) async {
    try {
      var url = Uri.parse('$baseUrl/it5023e/delete_survey');
      var requestBody = json.encode({
        'token': token,
        'survey_id': surveyId,
      });

      var response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['meta']['code'] == '1000') {
          return {'success': true, 'message': 'Exercise deleted successfully'};
        } else {
          return {'success': false, 'message': responseData['meta']['message']};
        }
      } else {
        return {'success': false, 'message': 'Failed to delete exercise'};
      }
    } catch (e) {
      print('Error during API request: $e');
      return {'success': false, 'message': 'Error during API request'};
    }
  }
}
