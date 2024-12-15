import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/class.dart';

class ListClassService {
  final String apiUrl = "http://157.66.24.126:8080";

  Future<List<Class>> fetchClasses(
      {required String token, required String role}) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/it5023e/get_class_list'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "token": token,
          "role": role,
          "account_id": "24",
          "pageable_request": {"page": "0", "page_size": "20"}
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(utf8.decode(response.bodyBytes));
        final Map<String, dynamic> responseData =
            json.decode(utf8.decode(response.bodyBytes));

        final List<dynamic> pageContent = responseData['data']['page_content'];

        List<Class> classes =
            pageContent.map((item) => Class.fromJson(item)).toList();

        return classes;
      } else {
        throw Exception('Failed to fetch classes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching classes: $e');
      return [];
    }
  }
}
