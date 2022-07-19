import 'dart:convert';

import 'package:equatable/equatable.dart';

class LiveChatMessage extends Equatable {
  final String? id;
  final String message;
  final int userId;
  final String username;
  final String firstName;
  final String lastName;
  final String? userPhoto;
  final String? userCoverPhoto;
  final String email;
  final int timestamp;
  const LiveChatMessage({
    this.id,
    required this.message,
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
    this.userPhoto,
    this.userCoverPhoto,
    required this.email,
    required this.timestamp, 
  });

  LiveChatMessage copyWith({
    String? id,
    String? message,
    int? userId,
    String? username,
    String? firstName,
    String? lastName,
    String? userPhoto,
    String? userCoverPhoto,
    String? email,
    int? timestamp
  }) {
    return LiveChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      userPhoto: userPhoto ?? this.userPhoto,
      userCoverPhoto: userCoverPhoto ?? this.userCoverPhoto,
      email: email ?? this.email,
      timestamp: this.timestamp
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
      'userId': userId,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'userPhoto': userPhoto,
      'userCoverPhoto': userCoverPhoto,
      'email': email,
      'timestamp': timestamp,
    };
  }

  factory LiveChatMessage.fromMap(Map<String, dynamic> map) {
    return LiveChatMessage(
      id: map['id'],
      message: map['message'] ?? '',
      userId: map['userId']?.toInt() ?? 0,
      username: map['username'] ?? '',
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      userPhoto: map['userPhoto'] ?? '',
      userCoverPhoto: map['userCoverPhoto'] ?? '',
      email: map['email'] ?? '',
      timestamp: map['timestamp'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory LiveChatMessage.fromJson(String source) =>
      LiveChatMessage.fromMap(json.decode(source));

  @override
  String toString() {
    return 'LiveChatMessage(id: $id, message: $message, userId: $userId, username: $username, firstName: $firstName, lastName: $lastName, userPhoto: $userPhoto, userCoverPhoto: $userCoverPhoto, email: $email, timestamp: $timestamp)';
  }

  @override
  List<Object> get props {
    return [
      id!,
      message,
      userId,
      username,
      firstName,
      lastName,
      userPhoto!,
      userCoverPhoto!,
      email,
      timestamp
    ];
  }
}
