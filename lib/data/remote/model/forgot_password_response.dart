// To parse this JSON data, do
//
//     final forgotPasswordResponse = forgotPasswordResponseFromJson(jsonString);

import 'dart:convert';

ForgotPasswordResponse forgotPasswordResponseFromJson(String str) =>
    ForgotPasswordResponse.fromJson(json.decode(str));

String forgotPasswordResponseToJson(ForgotPasswordResponse data) =>
    json.encode(data.toJson());

class ForgotPasswordResponse {
  ForgotPasswordResponse({
    required this.status,
    required this.message,
    // this.token,
  });

  String status;
  String message;
  // Token? token;

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponse(
        status: json["status"],
        message: json["message"],
        // token: Token.fromJson(json["token"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        // "token": token?.toJson(),
      };
}

class Token {
  Token({
    this.email,
    required this.token,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  String? email;
  int token;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        email: json["email"],
        token: json["token"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "token": token,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
