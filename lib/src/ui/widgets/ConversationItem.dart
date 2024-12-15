import 'package:flutter/material.dart';

class ConversationItem extends StatelessWidget {

  final String name;
  final String lastMessage;
  final String createdAt;
  final int unreadCount;

  const ConversationItem({
    Key? key,
    required this.name,
    required this.lastMessage,
    required this.createdAt,
    required this.unreadCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Icon(Icons.person), // Placeholder cho avatar
        backgroundColor: Colors.grey.shade300,
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
