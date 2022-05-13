// To parse this JSON data, do
//
//     final deleteFeedResponse = deleteFeedResponseFromJson(jsonString);

import 'dart:convert';

DeleteFeedResponse deleteFeedResponseFromJson(String str) => DeleteFeedResponse.fromJson(json.decode(str));

String deleteFeedResponseToJson(DeleteFeedResponse data) => json.encode(data.toJson());

class DeleteFeedResponse {
  DeleteFeedResponse({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory DeleteFeedResponse.fromJson(Map<String, dynamic> json) => DeleteFeedResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
