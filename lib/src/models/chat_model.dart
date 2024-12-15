class ChatResponse {
  final List<Conversation> conversations;
  final int numNewMessages;

  ChatResponse({
    required this.conversations,
    required this.numNewMessages,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      conversations: (json['data']['conversations'] as List)
          .map((conversation) => Conversation.fromJson(conversation))
          .toList(),
      numNewMessages: int.parse(json['data']['num_new_message']),
    );
  }
}

class Conversation {
  final int id;
  final Partner partner;
  final LastMessage lastMessage;

  Conversation({
    required this.id,
    required this.partner,
    required this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      partner: Partner.fromJson(json['partner']),
      lastMessage: LastMessage.fromJson(json['last_message']),
    );
  }
}

class Partner {
  final int id;
  final String name;
  final String? avatar;

  Partner({required this.id, required this.name, this.avatar});

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}

class LastMessage {
  final Sender sender;
  final String message;
  final DateTime createdAt;
  final int unread;

  LastMessage({
    required this.sender,
    required this.message,
    required this.createdAt,
    required this.unread,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      sender: Sender.fromJson(json['sender']),
      message: json['message'],
      createdAt: DateTime.parse(json['created_at']),
      unread: json['unread'],
    );
  }
}

class Sender {
  final int id;
  final String name;
  final String? avatar;

  Sender({required this.id, required this.name, this.avatar});

  factory Sender.fromJson(Map<String, dynamic> json) {
    return Sender(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }
}
