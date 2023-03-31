// To parse this JSON data, do
//
//     final chatMessageResponse = chatMessageResponseFromMap(jsonString);

import 'conversation.dart';

class ConversationMessagesResponse {
  ConversationMessagesResponse({
    required this.status,
    required this.conversationData,
  });

  final String status;
  final ConversationData conversationData;

  ConversationMessagesResponse copyWith({
    String? status,
    ConversationData? chatData,
  }) =>
      ConversationMessagesResponse(
        status: status ?? this.status,
        conversationData: chatData ?? conversationData,
      );

  factory ConversationMessagesResponse.fromMap(Map<String, dynamic> json) => ConversationMessagesResponse(
    status: json["status"],
    conversationData: ConversationData.fromMap(json["conversation"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "conversation": conversationData.toMap(),
  };
}

class ConversationData {
  ConversationData({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.channel,
    required this.createdAt,
    required this.updatedAt,
    required this.messages,
    required this.user1,
    required this.user2
  });

  final int id;
  final String user1Id;
  final String user2Id;
  final String channel;
  final ConversationUser user1;
  final ConversationUser user2;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Message> messages;

  ConversationData copyWith({
    int? id,
    String? user1Id,
    String? user2Id,
    String? channel,
    ConversationUser? user1,
    ConversationUser? user2,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Message>? messages,
  }) =>
      ConversationData(
        id: id ?? this.id,
        user1Id: user1Id ?? this.user1Id,
        user2Id: user2Id ?? this.user2Id,
        channel: channel ?? this.channel,
        user1: user1 ?? this.user1,
        user2: user2 ?? this.user2,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        messages: messages ?? this.messages,
      );

  factory ConversationData.fromMap(Map<String, dynamic> json) => ConversationData(
    id: json["id"],
    user1Id: json["user1_id"],
    user2Id: json["user2_id"],
    channel: json["channel"],
    user1: ConversationUser.fromMap(json["user1"]),
    user2: ConversationUser.fromMap(json["user2"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    messages: List<Message>.from(json["messages"].map((x) => Message.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user1_id": user1Id,
    "user2_id": user2Id,
    "channel": channel,
    "user1":user1.toMap(),
    "user2":user2.toMap(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "messages": List<Message>.from(messages.map((x) => x.toMap())),
  };
}