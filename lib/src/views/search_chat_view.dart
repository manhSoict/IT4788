import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_4788/src/views/chat_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_seach.dart'; // Import file model User

class SearchChat extends StatefulWidget {
  const SearchChat({Key? key}) : super(key: key);

  @override
  _SearchChatState createState() => _SearchChatState();
}

class _SearchChatState extends State<SearchChat> {
  List<UserSearch> searchResults = [];
  TextEditingController searchController = TextEditingController();

  Future<void> fetchUsers(String query) async {
    final url = Uri.parse("http://157.66.24.126:8080/it5023e/search_account");
    final body = jsonEncode({
      "search": query,
      "pageable_request": {"page": "0", "page_size": "20"}
    });

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));
        final List<dynamic> usersJson =
            responseData['data']['page_content'] ?? [];

        setState(() {
          searchResults =
              usersJson.map((user) => UserSearch.fromJson(user)).toList();
        });
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      final query = searchController.text;
      if (query.isNotEmpty) {
        fetchUsers(query);
      } else {
        setState(() {
          searchResults.clear();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tìm kiếm người dùng'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Nhập tên người dùng...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final user = searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    child:
                        Text(user.firstName[0]), // Hiển thị ký tự đầu của tên
                  ),
                  title:
                      Text("${user.firstName} ${user.lastName}"), // Tên đầy đủ
                  subtitle: Text(user.email), // Email của người dùng
                  onTap: () {
                    _clickConversation(user
                        .accountId); // Tìm và lưu conversationId khi người dùng chọn
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Hàm gọi fetchfindConversationId và lưu conversationId vào SharedPreferences
  void _clickConversation(String accountId) async {
    print(accountId);
    await fetchfindConversationId(accountId); // Gọi hàm tìm conversationId

    // Sau khi tìm và lưu conversationId, bạn có thể điều hướng đến màn hình ChatView hoặc làm gì đó khác
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatView(), // Màn hình ChatView, ví dụ
      ),
    );
  }

  // Hàm fetchfindConversationId
  Future<void> fetchfindConversationId(String partnerId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    const String url =
        'http://157.66.24.126:8080/it5023e/get_list_conversation';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"token": token, "index": "0", "count": "20"}),
    );

    String conversationId = '-1'; // Giá trị mặc định nếu không tìm thấy

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final List conversations = data['data']['conversations'] ?? [];

      // Tìm conversationId dựa trên partnerId
      for (var conversation in conversations) {
        print(conversation['partner']['id'].toString());
        if (conversation['partner']['id'].toString() == partnerId) {
          conversationId = conversation['id'].toString();
          print("Found conversationId: $conversationId");
          break;
        } else {
          print("tìm ko thấy");
          print(conversationId);
        }
      }
    } else {
      print("Error: ${response.statusCode}");
    }

    // Lưu conversationId vào SharedPreferences
    await prefs.setString('conversationId', conversationId);
  }
}
