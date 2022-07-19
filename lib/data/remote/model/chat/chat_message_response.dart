// To parse this JSON data, do
//
//     final chatMessageResponse = chatMessageResponseFromMap(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

import 'conversation.dart';

ChatMessageResponse chatMessageResponseFromMap(String str) => ChatMessageResponse.fromMap(json.decode(str));

String chatMessageResponseToMap(ChatMessageResponse data) => json.encode(data.toMap());

class ChatMessageResponse {
  ChatMessageResponse({
    required this.status,
    required this.chatData,
  });

  final String status;
  final ChatData chatData;

  ChatMessageResponse copyWith({
    String? status,
    ChatData? chatData,
  }) =>
      ChatMessageResponse(
        status: status ?? this.status,
        chatData: chatData ?? this.chatData,
      );

  factory ChatMessageResponse.fromMap(Map<String, dynamic> json) => ChatMessageResponse(
    status: json["status"],
    chatData: ChatData.fromMap(json["chat_data"]),
  );

  Map<String, dynamic> toMap() => {
    "status": status,
    "chat_data": chatData.toMap(),
  };
}

class ChatData {
  ChatData({
    required this.conversation,
    required this.message,
  });

  final Conversation conversation;
  final Message message;

  ChatData copyWith({
    Conversation? conversation,
    Message? message,
  }) =>
      ChatData(
        conversation: conversation ?? this.conversation,
        message: message ?? this.message,
      );

  factory ChatData.fromMap(Map<String, dynamic> json) => ChatData(
    conversation: Conversation.fromMap(json["conversation"]),
    message: Message.fromMap(json["message"]),
  );

  Map<String, dynamic> toMap() => {
    "conversation": conversation.toMap(),
    "message": message.toMap(),
  };
}