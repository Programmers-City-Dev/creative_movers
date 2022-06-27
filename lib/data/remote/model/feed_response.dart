// To parse this JSON data, do
//
//     final feedResponse = feedResponseFromJson(jsonString);

import 'dart:convert';

AddFeedResponse feedResponseFromJson(String str) =>
    AddFeedResponse.fromJson(json.decode(str));

String feedResponseToJson(AddFeedResponse data) => json.encode(data.toJson());

class AddFeedResponse {
  AddFeedResponse({
    this.status,
    this.addedFeed,
    this.message,
  });


  String? status;
  AddedFeed? addedFeed;
  String? message;

  factory AddFeedResponse.fromJson(Map<String, dynamic> json) => AddFeedResponse(
        status: json["status"],
        addedFeed: AddedFeed.fromJson(json["added_feed"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "added_feed": addedFeed?.toJson(),
        "message": message,
      };
}

class AddedFeed {
  AddedFeed({
    this.userId,
    this.type,
    this.content,
    this.media,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? userId;
  String? type;
  String? content;
  String? media;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory AddedFeed.fromJson(Map<String, dynamic> json) => AddedFeed(
        userId: json["user_id"],
        type: json["type"],
        content: json["content"],
        media: json["media"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "type": type,
        "content": content,
        "media": media,
        "updated_at": updatedAt.toString(),
        "created_at": createdAt.toString(),
        "id": id,
      };
}
