import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'package:creative_movers/data/remote/model/payment_history_data.dart';

class ChatMessage extends Equatable {
  final String? id;
  final String message;
  final String image;
  final int timestamp;
  final User user;

  const ChatMessage({
    this.id,
    required this.message,
    required this.image,
    required this.timestamp,
    required this.user,
  });

  ChatMessage copyWith({
    String? id,
    String? message,
    String? image,
    int? timestamp,
    User? user,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      image: image ?? this.image,
      timestamp: timestamp ?? this.timestamp,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'image': image,
      'timestamp': timestamp,
      'user': user.toMap(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] ?? '',
      message: map['message'] ?? '',
      image: map['image'] ?? '',
      timestamp: map['timestamp']?.toInt() ?? 0,
      user: User.fromMap(map['user']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CHatMessage(id: $id, message: $message, image: $image, timestamp: $timestamp, user: $user)';
  }

  @override
  List<Object> get props {
    return [
      id!,
      message,
      image,
      timestamp,
      user,
    ];
  }
}
