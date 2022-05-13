// To parse this JSON data, do
//
//     final likeResponse = likeResponseFromJson(jsonString);

import 'dart:convert';

LikeResponse likeResponseFromJson(String str) =>
    LikeResponse.fromJson(json.decode(str));

String likeResponseToJson(LikeResponse data) => json.encode(data.toJson());

class LikeResponse {
  LikeResponse({
    required this.status,
    required this.totalLike,
    required this.message,
  });

  String status;
  int totalLike;
  String message;

  factory LikeResponse.fromJson(Map<String, dynamic> json) => LikeResponse(
        status: json["status"],
        totalLike: json["total_like"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "total_like": totalLike,
        "message": message,
      };
}
