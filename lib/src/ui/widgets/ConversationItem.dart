import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {
  final String partnerId;
  final String name;
  final String lastMessage;
  final String createdAt;
  final int unreadCount;
  final Image? partnerImg;
  final VoidCallback? onTap; // Sự kiện khi nhấn vào mục

  const ConversationItem({
    Key? key,
    required this.partnerId,
    required this.name,
    required this.lastMessage,
    required this.createdAt,
    required this.unreadCount,
    this.partnerImg,
    this.onTap, // Sự kiện truyền từ bên ngoài
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap, // Kích hoạt sự kiện khi nhấn vào mục
      leading: CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        backgroundImage: partnerImg?.image,
        child:
            partnerImg == null ? Icon(Icons.person, color: Colors.white) : null,
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: unreadCount > 0
          ? CircleAvatar(
              backgroundColor: Colors.red,
              radius: 10,
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          : null,
    );
  }
}
