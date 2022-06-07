
class Conversation {
  Conversation({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.channel,
    required this.createdAt,
    required this.updatedAt,
    required this.unreadMessages,
    required this.user1,
    required this.user2,
    required this.lastMessage,
  });

  int id;
  String user1Id;
  String user2Id;
  String channel;
  DateTime createdAt;
  DateTime updatedAt;
  int? unreadMessages;
  ConversationUser? user1;
  ConversationUser? user2;
  Message? lastMessage;

  Conversation copyWith({
    int? id,
    String? user1Id,
    String? user2Id,
    String? channel,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? unreadMessages,
    ConversationUser? user1,
    ConversationUser? user2,
    Message? lastMessage,
  }) =>
      Conversation(
        id: id ?? this.id,
        user1Id: user1Id ?? this.user1Id,
        user2Id: user2Id ?? this.user2Id,
        channel: channel ?? this.channel,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        unreadMessages: unreadMessages ?? this.unreadMessages,
        user1: user1 ?? this.user1,
        user2: user2 ?? this.user2,
        lastMessage: lastMessage ?? this.lastMessage,
      );

  factory Conversation.fromMap(Map<String, dynamic> json) => Conversation(
    id: json["id"],
    user1Id: json["user1_id"].toString(),
    user2Id: json["user2_id"].toString(),
    channel: json["channel"].toString(),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    unreadMessages: json["unread_messages"] ?? 0,
    user1: json["user1"] == null ? null : ConversationUser.fromMap(json["user1"]),
    user2: json["user2"] == null ? null : ConversationUser.fromMap(json["user2"]),
    lastMessage: json["last_message"] == null ? null : Message.fromMap(json["last_message"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user1_id": user1Id,
    "user2_id": user2Id,
    "channel": channel,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "unread_messages": unreadMessages,
    "user1": user1 == null ? null : user1!.toMap(),
    "user2": user2 == null ? null: user2!.toMap(),
    "last_message": lastMessage == null ? null : lastMessage!.toMap(),
  };
}


class ConversationUser {
  ConversationUser({
    required this.id,
    this.firstname,
    this.lastname,
    required this.username,
    required this.profilePhotoPath,
  });

  int id;
  String? firstname;
  String? lastname;
  String username;
  String? profilePhotoPath;

  ConversationUser copyWith({
    int? id,
    String? firstname,
    String? lastname,
    String? username,
    String? profilePhotoPath,
  }) =>
      ConversationUser(
        id: id ?? this.id,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        username: username ?? this.username,
        profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      );

  factory ConversationUser.fromMap(Map<String, dynamic> json) => ConversationUser(
    id: json["id"],
    firstname: json["firstname"],
    lastname: json["lastname"],
    username: json["username"],
    profilePhotoPath: json["profile_photo_path"],
  );

  Map<String, dynamic> toMap() => {
    "id":id,
    "firstname": firstname,
    "lastname": lastname,
    "username": username,
    "profile_photo_path": profilePhotoPath,
  };
}



class Message {
  Message({
    required this.id,
    required this.userId,
    required this.body,
    required this.conversationId,
    required this.media,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.profilePhotoPath,
    this.shouldLoad
  });

  int id;
  String userId;
  String body;
  String conversationId;
  List<dynamic> media;
  String? profilePhotoPath;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  bool? shouldLoad;

  Message copyWith({
    int? id,
    String? userId,
    String? body,
    String? conversationId,
    List<String>? media,
    String? profilePhotoPath,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? shouldLoad
  }) =>
      Message(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        body: body ?? this.body,
        conversationId: conversationId ?? this.conversationId,
        media: media ?? this.media,
        profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
        status: status ?? this.status,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        shouldLoad: shouldLoad ?? this.shouldLoad
      );

  factory Message.fromMap(Map<String, dynamic> json) => Message(
    id: json["id"],
    userId: json["user_id"].toString(),
    body: json["body"],
    conversationId: json["conversation_id"].toString(),
    media: List<String>.from(json["media"].map((x) => x)),
    status: json["status"].toString(),
    profilePhotoPath: json["profile_photo_path"].toString(),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "user_id": userId,
    "body": body,
    "conversation_id": conversationId,
    "media": List<dynamic>.from(media.map((x) => x)),
    "status":status,
    "profile_photo_path":profilePhotoPath,
    "created_at": createdAt.toIso8601String(),
    "updated_at":updatedAt.toIso8601String(),
  };
}

class MessageUser {
  MessageUser({
    required this.id,
    this.profilePhotoPath,
  });

  final int id;
  final String? profilePhotoPath;

  MessageUser copyWith({
    int? id,
    String? profilePhotoPath,
  }) =>
      MessageUser(
        id: id ?? this.id,
        profilePhotoPath: profilePhotoPath ?? this.profilePhotoPath,
      );

  factory MessageUser.fromMap(Map<String, dynamic> json) =>
      MessageUser(
        id: json["id"],
        profilePhotoPath: json["profile_photo_path"],
      );

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "profile_photo_path": profilePhotoPath,
      };
}
