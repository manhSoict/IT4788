import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ExerciseService {
  static const String baseUrl = 'http://157.66.24.126:8080'; // Update base URL if needed

  Future<Map<String, dynamic>> createExercise({
    required String token,
    required String classId,
    required String title,
    required String deadline,
    required String description,
    required File file,  // File to upload
  }) async {
    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/it5023e/create_survey?file=null'),
      );

      // Add file to the request
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      // Add other fields
      request.fields['token'] = token;
      request.fields['classId'] = classId;
      request.fields['title'] = title;
      request.fields['deadline'] = deadline;
      request.fields['description'] = description;

      // Send the request
      var response = await request.send();

      // Process the response
      if (response.statusCode == 200) {
        // Read response as a string
        var responseBody = await response.stream.bytesToString();
        var responseData = json.decode(responseBody);

        // Check for success in the response
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
}
