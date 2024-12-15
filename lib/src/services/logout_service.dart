import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LogoutService {
  static const String baseUrl = 'http://157.66.24.126:8080';
  // Thay bằng URL API của bạn

  static Future<bool> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/it4788/logout'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['success'] ??
            false; // Kiểm tra xem phản hồi có thành công không
      } else {
        return false; // Nếu mã phản hồi không phải 200
      }
    } catch (e) {
      print('Error during logout: $e');
      return false; // Nếu gặp lỗi
    }
  }
}
