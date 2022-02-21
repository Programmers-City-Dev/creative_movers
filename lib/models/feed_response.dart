// To parse this JSON data, do
//
//     final feedResponse = feedResponseFromJson(jsonString);

import 'dart:convert';

FeedResponse feedResponseFromJson(String str) =>
    FeedResponse.fromJson(json.decode(str));

String feedResponseToJson(FeedResponse data) => json.encode(data.toJson());

class FeedResponse {
  FeedResponse({
    this.status,
    this.addedFeed,
    this.message,
  });


  String? status;
  AddedFeed? addedFeed;
  String? message;

  factory FeedResponse.fromJson(Map<String, dynamic> json) => FeedResponse(
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

  int? userId;
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
