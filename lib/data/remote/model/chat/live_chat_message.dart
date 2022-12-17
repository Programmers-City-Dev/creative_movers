import 'dart:convert';

import 'package:equatable/equatable.dart';

class LiveChatMessage extends Equatable {
  final LiveChatUser? user;
  final String? message;
  final String? token;

  const LiveChatMessage({this.user, this.message, this.token});

  factory LiveChatMessage.fromMap(Map<String, dynamic> data) {
    return data['live_chat_data'] == null
        ? LiveChatMessage(
            user: data['user'] == null
                ? null
                : LiveChatUser.fromMap(data['user'] as Map<String, dynamic>),
            message: data['message'] as String?,
            token: data['token'] as String?,
          )
        : LiveChatMessage(
            user: data['live_chat_data']['user'] == null
                ? null
                : LiveChatUser.fromMap(
                    data['live_chat_data']['user'] as Map<String, dynamic>),
            message: data['live_chat_data']['message'] as String?,
            token: data['live_chat_data']['token'] as String?,
          );
  }

  Map<String, dynamic> toMap() => {
        'user': user?.toMap(),
        'message': message,
        'token': token,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LiveChatMessage].
  factory LiveChatMessage.fromJson(String data) {
    return LiveChatMessage.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LiveChatMessage] to a JSON string.
  String toJson() => json.encode(toMap());

  LiveChatMessage copyWith({
    LiveChatUser? user,
    String? message,
    String? token,
  }) {
    return LiveChatMessage(
      user: user ?? this.user,
      message: message ?? this.message,
      token: token ?? this.token,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [user, message, token];
}

class LiveChatUser extends Equatable {
  final int? id;
  final String? firstname;
  final String? lastname;
  final String? username;
  final String? profilePhotoPath;

  const LiveChatUser({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.profilePhotoPath,
  });

  factory LiveChatUser.fromMap(Map<String, dynamic> data) => LiveChatUser(
        id: data['id'] as int?,
        firstname: data['firstname'] as String?,
        lastname: data['lastname'] as String?,
        username: data['username'] as String?,
        profilePhotoPath: data['profile_photo_path'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'profile_photo_path': profilePhotoPath,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [LiveChatUser].
  factory LiveChatUser.fromJson(String data) {
    return LiveChatUser.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [LiveChatUser] to a JSON string.
  String toJson() => json.encode(toMap());

  LiveChatUser copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    String? profilePhotoPath,
  }) {
    return LiveChatUser(
      id: id ?? this.id,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      username: username ?? this.username,
      profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      firstname,
      lastname,
      username,
      profilePhotoPath,
    ];
  }
}
