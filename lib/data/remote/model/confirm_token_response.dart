// To parse this JSON data, do
//
//     final confirmToken = confirmTokenFromJson(jsonString);

import 'dart:convert';

ConfirmTokenResponse confirmTokenFromJson(String str) => ConfirmTokenResponse.fromJson(json.decode(str));

String confirmTokenToJson(ConfirmTokenResponse data) => json.encode(data.toJson());

class ConfirmTokenResponse {
  ConfirmTokenResponse({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory ConfirmTokenResponse.fromJson(Map<String, dynamic> json) => ConfirmTokenResponse(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}
