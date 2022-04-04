// To parse this JSON data, do
//
//     final createPageResponse = createPageResponseFromJson(jsonString);

import 'dart:convert';

CreatePageResponse createPageResponseFromJson(String str) => CreatePageResponse.fromJson(json.decode(str));

String createPageResponseToJson(CreatePageResponse data) => json.encode(data.toJson());

class CreatePageResponse {
  CreatePageResponse({
    this.status,
    this.message,
  });

  String? status;
  String? message;

  factory CreatePageResponse.fromJson(Map<String, dynamic> json) => CreatePageResponse(
    status: json["status"] == null ? null : json["status"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status == null ? null : status,
    "message": message == null ? null : message,
  };
}
