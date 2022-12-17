// To parse this JSON data, do
//
//     final conversationsResponse = conversationsResponseFromMap(jsonString);

import 'dart:convert';

import 'conversation.dart';

ConversationsResponse conversationsResponseFromMap(String str) =>
    ConversationsResponse.fromMap(json.decode(str));

String conversationsResponseToMap(ConversationsResponse data) =>
    json.encode(data.toMap());

class ConversationsResponse {
  ConversationsResponse({
    required this.status,
    required this.conversations,
  });

  String status;
  List<Conversation> conversations;

  ConversationsResponse copyWith({
    String? status,
    List<Conversation>? conversations,
  }) =>
      ConversationsResponse(
        status: status ?? this.status,
        conversations: conversations ?? this.conversations,
      );

  factory ConversationsResponse.fromMap(Map<String, dynamic> json) =>
      ConversationsResponse(
        status: json["status"],
        conversations: json["conversations"] == null
            ? []
            : List<Conversation>.from(
                json["conversations"].map((x) => Conversation.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "conversations":
            List<dynamic>.from(conversations.map((x) => x.toMap())),
      };
}
//
// class Conversation {
//   Conversation({
//     required this.id,
//     required this.user1Id,
//     required this.user2Id,
//     required this.channel,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.unreadMessages,
//     required this.user1,
//     required this.user2,
//     required this.lastMessage,
//   });
//
//   int id;
//   String user1Id;
//   String user2Id;
//   String channel;
//   DateTime createdAt;
//   DateTime updatedAt;
//   int unreadMessages;
//   ConversationUser user1;
//   ConversationUser user2;
//   Message lastMessage;
//
//   Conversation copyWith({
//     int? id,
//     String? user1Id,
//     String? user2Id,
//     String? channel,
//     DateTime? createdAt,
//     DateTime? updatedAt,
//     int? unreadMessages,
//     ConversationUser? user1,
//     ConversationUser? user2,
//     Message? lastMessage,
//   }) =>
//       Conversation(
//         id: id ?? this.id,
//         user1Id: user1Id ?? this.user1Id,
//         user2Id: user2Id ?? this.user2Id,
//         channel: channel ?? this.channel,
//         createdAt: createdAt ?? this.createdAt,
//         updatedAt: updatedAt ?? this.updatedAt,
//         unreadMessages: unreadMessages ?? this.unreadMessages,
//         user1: user1 ?? this.user1,
//         user2: user2 ?? this.user2,
//         lastMessage: lastMessage ?? this.lastMessage,
//       );
//
//   factory Conversation.fromMap(Map<String, dynamic> json) => Conversation(
//     id: json["id"],
//     user1Id: json["user1_id"],
//     user2Id: json["user2_id"],
//     channel: json["channel"],
//     createdAt: DateTime.parse(json["created_at"]),
//     updatedAt: DateTime.parse(json["updated_at"]),
//     unreadMessages: json["unread_messages"],
//     user1: ConversationUser.fromMap(json["user1"]),
//     user2: ConversationUser.fromMap(json["user2"]),
//     lastMessage: Message.fromMap(json["last_message"]),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "id": id,
//     "user1_id": user1Id,
//     "user2_id": user2Id,
//     "channel": channel,
//     "created_at": createdAt.toIso8601String(),
//     "updated_at": updatedAt.toIso8601String(),
//     "unread_messages": unreadMessages,
//     "user1": user1.toMap(),
//     "user2": user2.toMap(),
//     "last_message": lastMessage.toMap(),
//   };
// }
