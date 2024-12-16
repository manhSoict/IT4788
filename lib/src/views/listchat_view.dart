import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_4788/src/ui/widgets/ConversationItem.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/components/footer.dart';

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
    String? token = prefs.getString('token');
    const String url =
        'http://157.66.24.126:8080/it5023e/get_list_conversation';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"token": token, "index": "0", "count": "20"}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      setState(() {
        conversations = data['data']['conversations'];
      });
    } else {
      print("Error: ${response.statusCode}");
    }
  }

  // void _showConversationDetails(String partnerId, String conversationId) {
  //   //Hiển thị đối thoại thông báo partnerId và conversation
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text('Thông tin Hội Thoại'),
  //       content: Text('Partner ID: $partnerId\nLast Message: $conversationId'),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.of(context).pop(),
  //           child: const Text('Đóng'),
  //         ),
  //       ],
  //     ),

  // }

  @override
  Widget build(BuildContext context) {
    var currentIndex = 1;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trò chuyện'),
      ),
      body: Stack(
        children: [
          // ListView hiển thị danh sách các cuộc trò chuyện
          ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              final conversationId = conversation['id'].toString();
              final partnerId = conversation['partner']['id'].toString();
              final partner = conversation['partner']['name'];
              final lastMessage = conversation['last_message']['message'];
              final createdAt = conversation['last_message']['created_at'];
              final unreadCount = conversation['last_message']['unread'];
              final partnerImg = conversation['partner']['avatar'];

              return ConversationItem(
                partnerId: partnerId,
                name: partner,
                lastMessage: lastMessage,
                createdAt: createdAt,
                unreadCount: unreadCount,
                partnerImg: partnerImg,
                onTap: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('partnerId', partnerId);
                  await prefs.setString('conversationId', conversationId);
                  Navigator.pushNamed(context, '/chatview');
                },
              );
            },
          ),

          // Nút NewChatButton ở góc phải dưới
          Positioned(
            bottom: 16.0, // Khoảng cách từ cạnh dưới
            right: 16.0, // Khoảng cách từ cạnh phải
            child: NewChatButton(
              assetIconPath: 'assets/icons/edit.png', // Thay đường dẫn icon
              onTap: () {
                // Xử lý sự kiện nhấn nút
                Navigator.pushNamed(context, '/searchchat');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(
        currentIndex: currentIndex,
      ),
    );
  }
}

class NewChatButton extends StatelessWidget {
  final String assetIconPath; // Đường dẫn asset icon
  final VoidCallback onTap; // Sự kiện khi nhấn vào

  const NewChatButton({
    Key? key,
    required this.assetIconPath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60, // Đường kính hình tròn
        height: 60,
        decoration: BoxDecoration(
          color: Colors.blue.shade100, // Màu nền của hình tròn
          shape: BoxShape.circle, // Hình dạng là hình tròn
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // Đổ bóng nhẹ
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            assetIconPath,
            width: 30, // Kích thước icon
            height: 30,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
