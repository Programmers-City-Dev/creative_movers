// To parse this JSON data, do
//
//     final postCommentResponse = postCommentResponseFromJson(jsonString);

import 'dart:convert';

import 'package:creative_movers/data/remote/model/feeds_response.dart';

PostCommentResponse postCommentResponseFromJson(String str) =>
    PostCommentResponse.fromJson(json.decode(str));

String postCommentResponseToJson(PostCommentResponse data) =>
    json.encode(data.toJson());

class PostCommentResponse {
  PostCommentResponse({
    required this.status,
    required this.comment,
    required this.message,
  });

  String status;
  Comment comment;
  String message;

  factory PostCommentResponse.fromJson(Map<String, dynamic> json) =>
      PostCommentResponse(
        status: json["status"],
        comment: Comment.fromJson(json["last_comment"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "last_comment": comment.toJson(),
        "message": message,
      };
}
