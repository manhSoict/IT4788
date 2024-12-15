import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_4788/src/ui/widgets/ConversationItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListChat extends StatefulWidget {
  const ListChat({Key? key}) : super(key: key);

  @override
  State<ListChat> createState() => _ListChatState();
}

class _ListChatState extends State<ListChat> {
  List conversations = [];

  @override
  void initState() {
    super.initState();
    fetchConversations();
  }

  Future<void> fetchConversations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token'); // Lấy token từ SharedPreferences
    const String url =
        'http://157.66.24.126:8080/it5023e/get_list_conversation'; // Thay link API

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"token": token, "index": "0", "count": "20"}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      // final data = jsonDecode(response.body);
      setState(() {
        conversations = data['data']['conversations'];
      });
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trò chuyện'),
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          final partner = conversation['partner']['name'];
          final lastMessage = conversation['last_message']['message'];
          final createdAt = conversation['last_message']['created_at'];
          final unreadCount = conversation['last_message']['unread'];

          return ConversationItem(
            name: partner,
            lastMessage: lastMessage,
            createdAt: createdAt,
            unreadCount: unreadCount,
          );
        },
      ),
    );
  }
}
