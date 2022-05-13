// To parse this JSON data, do
//
//     final resetPasswordResponse = resetPasswordResponseFromJson(jsonString);

import 'dart:convert';

ResetPasswordResponse resetPasswordResponseFromJson(String str) =>
    ResetPasswordResponse.fromJson(json.decode(str));

String resetPasswordResponseToJson(ResetPasswordResponse data) =>
    json.encode(data.toJson());

class ResetPasswordResponse {
  ResetPasswordResponse({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ResetPasswordResponse(
        status: json["status"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
