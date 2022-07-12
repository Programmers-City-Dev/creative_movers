// To parse this JSON data, do
//
//     final notificationsResponse = notificationsResponseFromMap(jsonString);

import 'dart:convert';

NotificationsResponse notificationsResponseFromMap(String str) =>
    NotificationsResponse.fromMap(json.decode(str));

String notificationsResponseToMap(NotificationsResponse data) =>
    json.encode(data.toMap());

class NotificationsResponse {
  NotificationsResponse({
    required this.status,
    required this.notifications,
    required this.message,
  });

  bool status;
  List<Notification> notifications;
  String message;

  NotificationsResponse copyWith({
    bool? status,
    List<Notification>? notifications,
    String? message,
  }) =>
      NotificationsResponse(
        status: status ?? this.status,
        notifications: notifications ?? this.notifications,
        message: message ?? this.message,
      );

  factory NotificationsResponse.fromMap(Map<String, dynamic> json) =>
      NotificationsResponse(
        status: json["status"],
        notifications: List<Notification>.from(
            json["notifications"].map((x) => Notification.fromMap(x))),
        message: json["message"],
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "notifications":
            List<Notification>.from(notifications.map((x) => x.toMap())),
        "message": message,
      };
}

class Notification {
  Notification({
    required this.id,
    required this.type,
    required this.notifiableType,
    required this.notifiableId,
    required this.data,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  String id;
  String type;
  String notifiableType;
  String notifiableId;
  NotificationData data;
  DateTime? readAt;
  DateTime createdAt;
  DateTime updatedAt;

  Notification copyWith({
    String? id,
    String? type,
    String? notifiableType,
    String? notifiableId,
    NotificationData? data,
    DateTime? readAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Notification(
        id: id ?? this.id,
        type: type ?? this.type,
        notifiableType: notifiableType ?? this.notifiableType,
        notifiableId: notifiableId ?? this.notifiableId,
        data: data ?? this.data,
        readAt: readAt ?? this.readAt,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Notification.fromMap(Map<String, dynamic> json) => Notification(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: NotificationData.fromMap(json["data"]),
        readAt:
            json["read_at"] == null ? null : DateTime.parse(json["read_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "type": type,
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "data": data.toMap(),
        "read_at": readAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class NotificationData {
  NotificationData({
    required this.type,
    required this.content,
    required this.myUserId,
  });

  String type;
  NotificationContent content;
  int myUserId;

  NotificationData copyWith({
    String? type,
    NotificationContent? content,
    int? myUserId,
  }) =>
      NotificationData(
        type: type ?? this.type,
        content: content ?? this.content,
        myUserId: myUserId ?? this.myUserId,
      );

  factory NotificationData.fromMap(Map<String, dynamic> json) =>
      NotificationData(
        type: json["type"],
        content: NotificationContent.fromMap(json["content"]),
        myUserId: json["my_user_id"],
      );

  Map<String, dynamic> toMap() => {
        "type": type,
        "content": content.toMap(),
        "my_user_id": myUserId,
      };
}

class NotificationContent {
  NotificationContent({
    required this.notifier,
    required this.data,
  });

  Notifier notifier;
  ContentData data;

  NotificationContent copyWith({
    Notifier? notifier,
    ContentData? data,
  }) =>
      NotificationContent(
        notifier: notifier ?? this.notifier,
        data: data ?? this.data,
      );

  factory NotificationContent.fromMap(Map<String, dynamic> json) =>
      NotificationContent(
        notifier: Notifier.fromMap(json["notifier"]),
        data: ContentData.fromMap(json["other_params"]),
      );

  Map<String, dynamic> toMap() => {
        "notifier": notifier.toMap(),
        "other_params": data.toMap(),
      };
}

class ContentData {
  ContentData(
      {required this.userId,
      required this.type,
      required this.content,
      required this.updatedAt,
      required this.createdAt,
      required this.id,
      required this.pageId});

  String? userId;
  String? type;
  String? content;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  int? pageId;

  ContentData copyWith({
    String? userId,
    String? type,
    String? content,
    DateTime? updatedAt,
    DateTime? createdAt,
    int? id,
    int? pageId,
  }) =>
      ContentData(
        userId: userId ?? this.userId,
        type: type ?? this.type,
        content: content ?? this.content,
        updatedAt: updatedAt ?? this.updatedAt,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        pageId: id ?? this.pageId,
      );

  factory ContentData.fromMap(Map<String, dynamic> json) => ContentData(
        userId: '${json["user_id"]}',
        type: json["type"],
        pageId: json["page_id"],
        content: json["content"],
        updatedAt:json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "type": type,
        "content": content,
        "updated_at":updatedAt == null ? null : updatedAt!.toIso8601String(),
        "created_at":createdAt==null ? null : createdAt!.toIso8601String(),
        "id": id,
        "page_id": pageId,
      };
}

class Notifier {
  Notifier({
    required this.id,
    required this.name,
    required this.avatar,
  });

  int id;
  String name;
  String? avatar;

  Notifier copyWith({
    int? id,
    String? name,
    String? avatar,
  }) =>
      Notifier(
        id: id ?? this.id,
        name: name ?? this.name,
        avatar: avatar ?? this.avatar,
      );

  factory Notifier.fromMap(Map<String, dynamic> json) => Notifier(
        id: json["id"],
        name: json["name"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "avatar": avatar,
      };
}
