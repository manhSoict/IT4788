import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Màn hình Chat
class ChatView extends StatefulWidget {
  const ChatView({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  List<Map<String, dynamic>> messages = []; // Danh sách tin nhắn
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? userId;
  String? partnerId;
  String? conversationId;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserId().then((_) {
      SharedPreferences.getInstance().then((prefs) {
        final token = prefs.getString('token');
        if (token != null && partnerId != null) {
          fetchInfoPartner(token, partnerId!);
        }
      });
    });
    fetchMessages();
  }

  Future<void> fetchCurrentUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final token = prefs.getString('token');
      userId = prefs.getString('userId');
      partnerId = prefs.getString('partnerId');
      conversationId = prefs.getString('conversationId');
      // print(userId); // Lấy userId hiện tại
    });
  }

  String? partnerName;
  String? partnerImg;

  Future<void> fetchInfoPartner(String token, String userId) async {
    const String url = "http://157.66.24.126:8080/it4788/get_user_info";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "token": token,
          "user_id": userId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        if (data['code'] == "1000") {
          final userInfo = data['data'];
          setState(() {
            partnerName = userInfo['name'];
            partnerImg = userInfo['avatar'];
          });
        } else {
          print("Lỗi: ${data['message']}");
        }
      } else {
        print("Lỗi kết nối: ${response.statusCode}");
      }
    } catch (e) {
      print("Đã xảy ra lỗi: $e");
    }
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
          "partner_id": partnerId,
          "conversation_id": conversationId,
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
        backgroundColor: Colors.white,
        title: Row(
          children: [
            CircleAvatar(
              radius: 12,
              backgroundColor: Colors.blueGrey,
              backgroundImage:
                  partnerImg != null ? NetworkImage(partnerImg!) : null,
              child: partnerImg == null
                  ? Text(
                      partnerName != null && partnerName!.isNotEmpty
                          ? partnerName!.substring(0, 1).toUpperCase()
                          : "",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    )
                  : null,
            ),
            const SizedBox(width: 5),
            Text(
              partnerName ?? "Đang tải...",
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.black),
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
