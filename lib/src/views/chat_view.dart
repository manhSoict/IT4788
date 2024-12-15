import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Màn hình Chat
class ChatView extends StatefulWidget {
  final String partnerId;
  final String conversationId;

  const ChatView({
    Key? key,
    required this.partnerId,
    required this.conversationId,
  }) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<Map<String, dynamic>> messages = []; // Danh sách tin nhắn
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserId();
    fetchMessages();
  }

  Future<void> fetchCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      print(userId); // Lấy userId hiện tại
    });
  }

  Future<void> fetchMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      print("Token is null or empty");
      return; // Trả về một Future<void> rỗng để tránh lỗi
    }

    const String url = "http://157.66.24.126:8080/it5023e/get_conversation";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode({
          "token": token,
          "index": "0",
          "count": "40",
          "partner_id": widget.partnerId,
          "conversation_id": widget.conversationId,
          "mark_as_read": "true",
        }),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          messages =
              List<Map<String, dynamic>>.from(data["data"]["conversation"]);
        });
      } else {
        print("Failed to load messages. Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching messages: $e");
    }
  }

  Widget buildMessage(Map<String, dynamic> message) {
    // Kiểm tra tin nhắn thuộc về người dùng hay đối phương
    bool isCurrentUser = message['sender']['id'].toString() == userId;
    DateTime? createdAt;

    // Chuyển đổi `created_at` thành DateTime (nếu có)
    if (message['created_at'] != null) {
      createdAt = DateTime.tryParse(message['created_at']);
    }

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[200] : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: isCurrentUser
                ? const Radius.circular(12)
                : const Radius.circular(0),
            bottomRight: isCurrentUser
                ? const Radius.circular(0)
                : const Radius.circular(12),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (createdAt != null) ...[
              const SizedBox(height: 4),
              Text(
                "${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')} - ${createdAt.day}/${createdAt.month}/${createdAt.year}",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
            // Nội dung tin nhắn
            Text(
              message['message'] ?? "",
              style: const TextStyle(fontSize: 16),
            ),
            // Thời gian gửi tin nhắn
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Màu nền trắng
        title: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.blueGrey,
              child: Text(
                "D2",
                style: TextStyle(
                    color: Colors.white, fontSize: 12), // Chữ bên trong avatar
              ),
            ),
            const SizedBox(width: 5),
            const Text(
              "Doan Van Nam",
              style:
                  TextStyle(color: Colors.black, fontSize: 16), // Màu chữ đen
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.videocam, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.call, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
        iconTheme:
            const IconThemeData(color: Colors.black), // Màu cho các icon back
      ),
      body: Column(
        children: [
          // Danh sách tin nhắn
          Expanded(
            child: messages.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return buildMessage(messages[index]);
                    },
                  ),
          ),

          // Thanh nhập tin nhắn
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.white, // Màu nền trắng cho thanh nhập
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    onChanged: (value) {
                      setState(() {
                        // Rebuild UI khi thay đổi nội dung
                      });
                    },
                    style: TextStyle(color: Colors.black), // Màu chữ đen
                    decoration: const InputDecoration(
                      hintText: "Nhập tin nhắn",
                      hintStyle:
                          TextStyle(color: Colors.grey), // Màu placeholder xám
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: _messageController.text.isEmpty
                      ? const Icon(Icons.add_circle_outline,
                          color: Colors.black)
                      : const Icon(Icons.send, color: Colors.black),
                  onPressed: () {
                    if (_messageController.text.trim().isNotEmpty) {
                      //sendMessage(_messageController.text.trim());
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
