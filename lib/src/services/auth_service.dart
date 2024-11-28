import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class AuthService {
  final String apiUrl = "http://157.66.24.126:8080/it4788";

  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
          'device_id': 1,
          'fcm_token': null,
        }),
      );

      if (response.statusCode == 200) {
        // final jsonData = json.decode(response.body);
        final jsonData = json.decode(utf8.decode(response.bodyBytes));

        if (jsonData['code'] == '1000') {
          return User.fromJson(jsonData['data']);
        } else {
          print('Error: ${jsonData['message']}');
        }
      } else {
        print('HTTP Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login: $e');
    }
    return null;
  }
}
